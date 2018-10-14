class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, only: %i[index]
  before_action :is_feature_enabled

  def index
    @projects = Project.all.paginate(page: params[:page], per_page: 20)
  end

  def search
    if params[:search].present?
      @projects = Project.search(params[:search], page: params[:page], per_page: 20)
    else
      redirect_to projects_path
    end
  end

  def show
    if current_user.is_attendee?
      if @project.user != current_user
        redirect_to index_path, alert: "You don't have the permissions to see this project."
      end
    end
  end


  def new
    if current_user.has_published_project?
      redirect_to project_path(current_user.project)
    end
    @project = Project.new
  end


  def edit
  end


  def create
    @project = Project.new(project_params)
    @project.user = current_user

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
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
    @project.destroy
    respond_to do |format|
      format.html { redirect_to index_path, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def is_feature_enabled
    feature_flag = FeatureFlag.find_by(name: 'projects')
    # Redirect user to index if no feature flag has been found
    if feature_flag.nil?
      redirect_to index_path, notice: 'Projects are currently not available. Try again later!'
    else
      if feature_flag.value == false
        # Redirect user to index if no feature flag is off (false)
        redirect_to index_path, alert: 'Projects are currently not available. Try again later!'
      end
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:title, :description, :link, :team_members, :projectimage, :inspiration, :does_what, :built_how, :challenges, :accomplishments, :learned, :next, :built_with, :power, prizes:[])
    end

    def check_permissions
      unless current_user.is_admin? or current_user.is_mentor? or current_user.is_organizer?
        redirect_to index_path, alert: 'You do not have the permissions to see all projects'
      end
    end
end
