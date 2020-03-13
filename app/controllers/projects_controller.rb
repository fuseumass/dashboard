class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :set_project_for_team, only: [:team, :add_team_member, :remove_team_member]
  before_action :check_project_view_active, only: [:index, :search, :public]
  before_action :check_project_create_active, only: [:new, :create, :update, :project_submit_info]
  before_action :delete_before_check, only: [:delete]
  skip_before_action :auth_user, :only => [:index, :show, :public]

  def index
    if HackumassWeb::Application::PROJECTS_PUBLIC and (not current_user or not current_user.is_organizer?)
      redirect_to public_projects_path
    else
      check_permissions
    end

    @projects = Project.all.paginate(page: params[:page], per_page: 20)
    @projectsCSV = Project.all

    respond_to do |format|
      format.html
      format.csv { send_data @projectsCSV.to_csv, filename: "projects.csv" }
    end
  end

  def search
    if params[:search].present?
      @projects = Project.joins(:user).where("lower(users.first_name) LIKE lower(?) OR
                                              lower(users.last_name) LIKE lower(?) OR
                                              lower(users.email) LIKE lower(?) OR
                                              lower(title) LIKE lower(?) OR
                                              lower(link) LIKE lower(?) OR
                                              table_id = ?",
                                            "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%",
                                            "%#{params[:search]}%", "%#{params[:search]}%", params[:search].match(/^(\d)+$/) ? params[:search].to_i : 99999)
    @projects = @projects.paginate(page: params[:page], per_page: 20)
    else
      redirect_to projects_path
    end
  end

  def public
    if params[:winners]
      @projects = Project.where("LENGTH(prizes_won::varchar) > ?", 2)
    elsif params[:prize]
      @projects = Project.where("prizes::varchar LIKE ?", "%#{params[:prize]}%")
    else
      @projects = Project.all
    end

    @winners_count = Project.where("LENGTH(prizes_won::varchar) > ?", 2).count

    @projects = @projects.order("created_at DESC").paginate(page: params[:page], per_page: 20)
  end

  def show
    projects_public = HackumassWeb::Application::PROJECTS_PUBLIC
    if (not projects_public) or (not check_feature_flag?($Projects))
      if current_user.is_attendee?
        if current_user.project_id != @project.id
          redirect_to index_path, alert: "Public access to projects is disallowed."
        end
      end
    end
  end


  def new
    if current_user.has_published_project?
      redirect_to project_path(current_user.project)
    else
      @project = Project.new
    end
  end


  def edit
    # Prevent users from editing their project when submissions/creation is closed.
    unless check_feature_flag?($project_submissions) or (current_user != nil and current_user.is_organizer?)
      if current_user != nil and current_user.project != nil
        redirect_to current_user.project, alert: 'You may not make changes to your project now.'
      else
        redirect_to index_path, alert: 'You may not make changes to your project now.'
      end
    end
    if not current_user.is_organizer? and @project.id != current_user.project_id
      redirect_to index_path, alert: "This isn't your assigned project."
    end
  end

  def create
    @project = Project.new(project_params)
    @project.user << current_user
    #@project.tech = []
    #@project.prizes = []
    #@project.prizes_won = []

    respond_to do |format|
      if @project.save
        format.html { redirect_to project_team_path(@project), notice: 'Project was successfully created. Please add additional team members by entering their email addresses.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy

    user_list = @project.user

    if !@project.destroy
      redirect_to project_path(current_user.project), alert: 'Unable to delete project.'
      return
    end

    user_list.each do |user|
      user.project_id = nil
      user.save
    end

    respond_to do |format|
      format.html { redirect_to index_path, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def project_submit_info
     if current_user.has_published_project?
        redirect_to project_path(current_user.project)
     elsif check_feature_flag?($project_submissions)
       if current_user.is_admin?
         redirect_to projects_path
       end
     else
       redirect_to index_path, alert: 'Error: Unable to create new project. Project creation and submission is currently disabled.'
    end
  end


  def team

    if not check_feature_flag?($project_submissions) and current_user.is_attendee?
      redirect_to current_user.project, alert: 'Error: Unable to modify team members while project creation is disabled.'
      return
    end
    unless current_user.is_admin? or current_user.is_organizer?
      if current_user.project_id != @project.id
        redirect_to index_path, alert: "You don't have permission to edit this project's team."
      elsif !check_feature_flag?($project_submissions)
        redirect_to index_path, alert: 'Error: Unable to create new project. Project creation and submission is currently disabled.'
      end
    end
  end

  def add_team_member

      if params[:add_team_member].present?
        @user = User.where(email: params[:add_team_member]).first
        if @user.nil?
          redirect_to project_team_path(@project), alert: "Unable to add team member. Ensure the email is spelled correctly."
        elsif !@user.project_id.nil?
          redirect_to project_team_path(@project), alert: "Unable to add team member. #{params[:add_team_member]} is already on a team."
        elsif @user.is_admin? or @user.is_mentor? or @user.is_organizer?
          redirect_to project_team_path(@project), alert: "Unable to add administrators, organizers, or mentors as a team member."
        else
          @project.user << @user
          redirect_to project_team_path(@project), notice: "#{params[:add_team_member]} successfully added to team."
        end
      else
        redirect_to project_team_path(@project), alert: "Unable to add team member. You must specify an email address."
      end
  end

  def remove_team_member
    @user = User.find(params[:user_to_remove])

    if @project.user.length <= 1
      redirect_to project_team_path(@project), alert: "Unable to remove team member. You must have at least one person on a project team. If you still wish to be removed, you can delete the project."
    elsif @user == current_user
      @project.user.delete(@user)
      @project.save
      redirect_to root_path(@project), notice: "You have removed yourself from the project team."
    else
      @project.user.delete(@user)
      @project.save
      redirect_to project_team_path(@project), notice: "Removed #{@user.email} from project team."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      begin
        @project = Project.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to index_path, alert: 'Looks like we could not find that project (404)'
      end
    end

    def set_project_for_team
      begin
        @project = Project.find(params[:project_id])
      rescue ActiveRecord::RecordNotFound
        redirect_to index_path, alert: 'Looks like we could not find that project (404)'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:title, :description, :link, :projectimage, :youtube_link, :inspiration, :does_what, :built_how, :challenges, :accomplishments, :learned, :next, :built_with, :power, tech:[], prizes:[])
    end

    def check_permissions
      unless current_user.is_admin? or current_user.is_mentor? or current_user.is_organizer?
        redirect_to index_path, alert: 'You do not have the permissions to see all projects'
      end
    end


    def check_project_view_active
      if current_user == nil
        unless check_feature_flag?($Projects)
          redirect_to index_path, alert: "Error: Access to project gallery is currently disabled."
        end
      else
        unless check_feature_flag?($Projects) or current_user.is_admin? or current_user.is_mentor? or current_user.is_organizer?
          redirect_to index_path, alert: "Error: Access to project gallery is currently disabled."
        end
      end
    end

    def check_project_create_active
      # Prevent access to creating/viewing project unless the user already has one
      unless check_feature_flag?($project_submissions) or current_user.has_published_project?
        redirect_to index_path, alert: 'Error: Unable to create new project. Project creation and submission is currently disabled.'
      end
    end

    def delete_before_check
      # Prevent users from deleting their project when submissions/creation is closed.
      unless check_feature_flag?($project_submissions) or (current_user != nil and current_user.is_organizer?)
        if current_user != nil and current_user.project != nil
          redirect_to current_user.project, alert: 'You may not make changes to your project now.'
        else
          redirect_to index_path, alert: 'You may not make changes to your project now.'
        end
      end
      if not current_user.is_organizer? and @project.id != current_user.project_id
        redirect_to index_path, alert: "This isn't your assigned project."
      end
    end

end
