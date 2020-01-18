class JudgingController < ApplicationController
  before_action -> { is_feature_enabled($Judging) }
  before_action :auth_user
  before_action :check_permissions
  before_action :check_organizer_permissions, only: [:search, :assign]
  def search
    if params[:search].present?
      @projects = Project.left_outer_joins(:judgement => :user).where("first_name LIKE lower(?) OR last_name LIKE lower(?) OR title LIKE lower(?) OR table_id = ?",
      "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", params[:search].match(/^(\d)+$/) ? params[:search].to_i : 99999)

      @projects = @projects.paginate(page: params[:page], per_page: 20)
    else
      redirect_to judging_index_path
    end
  end


  def index
    # @assigned = Judgement.where({user_id: current_user.id})
    @assigned = Project.joins(:judging_assignments)
    # .where("judging_assignments.user_id = ?", current_user.id)
    @projects = Project.all.paginate(page: params[:page], per_page: 20)
    @scores = Judgement.all

    @judgementsCSV = Judgement.all

    respond_to do |format|
      format.html
      format.csv { send_data @judgementsCSV.to_csv, filename: "judging.csv" }
    end
  end

  # GET route for assignment creation
  def assign
    @project = Project.find_by(id: params[:project_id])
    @assignments = JudgingAssignment.where(project_id: @project.id)
  end

  # POST route to assign a judge to a project
  def add_judge_assignment
    if (!params.has_key?(:project_id) or !params.has_key?(:judge_email))  # An error in params, likely when a user messes with the URL
      redirect_to judging_index_path, alert: 'Unable to assign judge to project. This is likely from accessing a 
      broken link or refreshing a submitted form. Please try to assign the judge again, and if this fails contact an administrator.'
    
    elsif (User.where(:email => params[:judge_email]).empty?)  # Make sure the email provided is valid
      redirect_to assign_judging_index_path(:project_id => params[:project_id]), alert: 'Invalid Judge Email Address.'
    
    elsif (User.where(:email => params[:judge_email]).first.user_type == 'attendee')  # Don't let normal attendee's judge projects
      redirect_to assign_judging_index_path(:project_id => params[:project_id]), alert: 'Error: Desired judge\'s account does not have sufficient permissions (they are a participant!).'
    
    else  # All is well, assign judge to project
      @judge_id = User.where(:email => params[:judge_email]).first.id
      @assignment = JudgingAssignment.new(:user_id => @judge_id, :project_id => params[:project_id])
      if @assignment.save
        redirect_to judging_index_path, notice: 'Successfully assigned judge to project.'
      else
        redirect_to assign_judging_index_path(:project_id => params[:project_id]), alert: 'Unable to assign judge to project.'
      end
    end
  end

  # POST route to unassign a judge from a project
  def remove_judge_assignment
    if (!params.has_key?(:project_id) or !params.has_key?(:judge_id))  # An error in params, likely when a user messes with the URL
      redirect_to judging_index_path, alert: 'Unable to remove judge from project. This is likely from accessing a 
      broken link or refreshing a submitted form. Please try to remove the judge again, and if this fails contact an administrator.'
    
    elsif (!JudgingAssignment.exists?(:user_id => params[:judge_id], :project_id => params[:project_id]))  # If no records match. When/if a user tries to change URL/request
      redirect_to assign_judging_index_path(:project_id => params[:project_id]), alert: 'Unable to remove assignment: The judge is not assigned to that project!'

    else  # All is correct, remove judge from project
      @assignment = JudgingAssignment.find_by(:user_id => params[:judge_id], :project_id => params[:project_id])
      @assignment.destroy
      respond_to do |format|
        format.html { redirect_to assign_judging_index_path(:project_id => params[:project_id]), notice: 'Successfully unassigned judge from project.' }
        format.json { head :no_content }
      end
    end
  end

  # GET route to submit a score for a project
  def show
    @judgement = Judgement.find_by(id: params[:id])
    if @judgement.nil?  # If no judgement assigned, create a new one
      
    else  # If one exists, check permissions and assignments
      if @judgement.score == -1 and @judgement.user_id == current_user.id  # If assigned
        @project = @judgement.project
      elsif @judgement.score == -1
        redirect_to judging_index_path, alert: 'Unable to judge project until assigned judge is removed.'
      end

    end
  end

  # POST route to submit a score for a project
  def assign_score
    
  end

  def destroy
    @assignment = Judgement.where(:id => params[:id]).first
    @assignment.destroy
    respond_to do |format|
      format.html { redirect_to judging_index_path, notice: 'Judge successfully unassigned.' }
      format.json { head :no_content }
    end
  end

  private

    # Only admin, organizers, and mentors are allowed to judge projects
    def check_permissions
      unless current_user.is_organizer? or current_user.is_mentor? or current_user.is_admin?
        redirect_to index_path, alert: 'You do not have permission to access judging.'
      end
    end

    # Only admin, organizers, and mentors are allowed to judge projects
    def check_organizer_permissions
      unless current_user.is_organizer? or current_user.is_admin?
        redirect_to index_path, alert: 'You do not have permission to access this judging feature.'
      end
    end
end
