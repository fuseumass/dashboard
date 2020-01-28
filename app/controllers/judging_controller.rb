class JudgingController < ApplicationController
  before_action -> { is_feature_enabled($Judging) }
  before_action :auth_user
  before_action :check_permissions
  before_action :check_organizer_permissions, only: [:search, :assign, :add_judge_assignment, :remove_judge_assignment]

  def search
    if params[:search].present?

      if params[:search] == 'status:assigned'
        @projects = Project.joins(:judging_assignments)
      elsif params[:search] == 'status:unassigned'
        @projects = Project.left_outer_joins(:judging_assignments).where("judging_assignments.project_id IS NULL")
      elsif params[:search] == 'status:judged'
        @projects = Project.joins(:judgements)
      elsif params[:search] == 'status:unjudged'
        @projects = Project.left_outer_joins(:judgements).where("judgements.project_id IS NULL")
      else
        @projects = Project.left_outer_joins(:judgements => :user).where("first_name LIKE lower(?) OR last_name LIKE lower(?) OR title LIKE lower(?) OR table_id = ?",
        "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", params[:search].match(/^(\d)+$/) ? params[:search].to_i : 99999)
      end
      @projects = @projects.paginate(page: params[:page], per_page: 20)
    else
      redirect_to judging_index_path
    end
  end


  def index
    @assigned = JudgingAssignment.all.where(user_id: current_user.id)
    @projects = Project.all.paginate(page: params[:page], per_page: 20)

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
      return
    end

    @judge_id = User.where(:email => params[:judge_email]).first.id
    if (User.where(:email => params[:judge_email]).empty?)  # Make sure the email provided is valid
      redirect_to assign_judging_index_path(:project_id => params[:project_id]), alert: 'Invalid Judge Email Address.'
    
    elsif (User.where(:email => params[:judge_email]).first.user_type == 'attendee')  # Don't let normal attendee's judge projects
      redirect_to assign_judging_index_path(:project_id => params[:project_id]), alert: 'Error: Desired judge\'s account does not have sufficient permissions (they are a participant!).'
    
    elsif (((!params.has_key?(:tag) or params[:tag] == '') and JudgingAssignment.exists?(:user_id => @judge_id, :project_id => params[:project_id], :tag => nil)) or (params.has_key?(:tag) and JudgingAssignment.exists?(:user_id => @judge_id, :project_id => params[:project_id], :tag => params[:tag])))  # If the judge is already assigned to this project.
      redirect_to assign_judging_index_path(:project_id => params[:project_id]), alert: 'Error: '+params[:judge_email]+' is already assigned to judge this project!'
    else  # All is well, assign judge to project
      if params.has_key?(:tag) and params[:tag] != ''
        @assignment = JudgingAssignment.new(:user_id => @judge_id, :project_id => params[:project_id], :tag => params[:tag])
      else
        @assignment = JudgingAssignment.new(:user_id => @judge_id, :project_id => params[:project_id])
      end
      if @assignment.save
        redirect_to assign_judging_index_path(:project_id => params[:project_id]), notice: 'Successfully assigned judge to project.'
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
  def new
    if (!params.has_key?(:project_id))
      redirect_to judging_index_path, alert: 'Error: Unable to load judging page. Please ensure that the link is valid and try again.'
    end

    if params[:tag].nil? or params[:tag] == ''
      @tag = nil
    else
      @tag = params[:tag]
    end

    @judgement = Judgement.new
    @judgement.custom_scores = {}

    @project = Project.find_by(id: params[:project_id])
    @project_id = params[:project_id]

    if (JudgingAssignment.exists?(:user_id => current_user.id, :project_id => @project.id, :tag => @tag))
      @assignment = JudgingAssignment.find_by(:user_id => current_user.id, :project_id => @project.id, :tag => @tag)
    else
      @assignment = nil
      unless (current_user.user_type == 'admin' or current_user.user_type == 'organizer')
        redirect_to judging_index_path, alert: 'Error: You may not judge a project that hasn\'t been assigned to you.'
      end
    end
  end


  # POST route to submit a score for a project
  def create
    @judgement = Judgement.new(judging_score_params)
    
    @judgement.project_id = judging_score_params[:project_id]
    @judgement.user_id = current_user.id

    if judging_score_params[:tag].nil? or judging_score_params[:tag] == ''
      @tag = nil
    else
      @tag = judging_score_params[:tag]
    end

    if (JudgingAssignment.exists?(:user_id => current_user.id, :project_id => judging_score_params[:project_id], :tag => @tag))
      @assignment = JudgingAssignment.find_by(:user_id => current_user.id, :project_id => judging_score_params[:project_id], :tag => @tag)
    else
      @assignment = nil
      unless (current_user.user_type == 'admin' or current_user.user_type == 'organizer')
        redirect_to judging_index_path, alert: 'Error: You may not judge a project that hasn\'t been assigned to you.'
      end
    end

    total_score = 0

    HackumassWeb::Application::JUDGING_CUSTOM_FIELDS.each do |c|
      total_score += judging_score_params['custom_scores'][c['name']].to_f
    end

    @judgement.score = total_score

    if @judgement.save
      if !@assignment.nil?
        @assignment.destroy
      end
      redirect_to judging_index_path, notice: 'Thank you for judging this project!'
    else
      redirect_to new_judging_path(:project_id => judging_score_params[:project_id], :tag => @tag), alert: 'Error: Unable to judge project. Please ensure all fields have a value.'
    end
  end


  # POST route to remove a score from a project
  def destroy
    @assignment = Judgement.where(:id => params[:id]).first
    @assignment.destroy
    respond_to do |format|
      format.html { redirect_to judging_index_path, notice: 'Judge successfully unassigned.' }
      format.json { head :no_content }
    end
  end


  def results
    if (!params.has_key?(:project_id))
      redirect_to judging_index_path, alert: 'Error: Unable to load results for project. Please ensure that the link is valid and try again.'
    end
    @project = Project.find_by(id: params[:project_id])
    @scores = Judgement.where(project_id: @project.id)
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

    # gives 
    def judging_score_params
      custom_scores_items = []
      HackumassWeb::Application::JUDGING_CUSTOM_FIELDS.each do |c|
        custom_scores_items << c['name'].to_sym
      end

      params.require(:judgement).permit(:project_id, :tag, custom_scores: custom_scores_items )
    end
end
