class JudgingController < ApplicationController
  before_action -> { is_feature_enabled($Judging) }
  before_action :auth_user
  before_action :check_permissions
  before_action :check_organizer_permissions, only: [:assign, :add_judge_assignment, :remove_judge_assignment]

  def index
    if params[:search].present? or params[:prize].present?

      if params[:search] == 'status:assigned'
        @projects = Project.joins(:judging_assignments)
      elsif params[:search] == 'status:unassigned'
        @projects = Project.left_outer_joins(:judging_assignments).where("judging_assignments.project_id IS NULL")
      elsif params[:search] == 'status:judged'
        @projects = Project.joins(:judgements)
      elsif params[:search] == 'status:unjudged'
        @projects = Project.left_outer_joins(:judgements).where("judgements.project_id IS NULL")
      elsif params[:prize]
        @projects = Project.where("prizes::varchar LIKE ?", "%#{params[:prize]}%")
      else
        @projects = Project.left_outer_joins(:judgements => :user).where("lower(first_name) LIKE lower(?) OR lower(last_name) LIKE lower(?) OR lower(title) LIKE lower(?) OR table_id = ?",
                                                                         "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", params[:search].match(/^(\d)+$/) ? params[:search].to_i : 99999)
      end

    else
      @projects = Project.all.order(table_id: :asc).paginate(page: params[:page], per_page: 15)
    end

    @judged_by_me = Judgement.where(user_id: current_user.id)
    @assigned = JudgingAssignment.all.where(user_id: current_user.id)
    @judgements = Judgement.all

    @projects = @projects.paginate(page: params[:page], per_page: 15)

    @times_judged = {}
    @open_judgements = {}
    @avg_score = {}
    # Tally up the individual counts per judgement
    if !@projects.nil? && !@projects.empty?
      @projects.each do |proj|
        project_judgements = Judgement.where(project_id: proj.id)
        @times_judged[proj.id] = project_judgements.count
        project_assignments = JudgingAssignment.where(project_id: proj.id)
        @open_judgements[proj.id] = project_assignments.count

        sum = 0
        project_judgements.each do |j|
          sum += j.score
        end

        if sum > 0
          @avg_score[proj.id] = sum / project_judgements.count
        else
          @avg_score[proj.id] = 0
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv {
        send_data @judgements.to_csv, filename: "judging.csv"
      }
    end
  end

  # GET route for assignment creation
  def assign
    @project = Project.find_by(id: params[:project_id])
    @assignments = JudgingAssignment.where(project_id: @project.id)
  end

  # POST route to assign a judge to a project
  def add_judge_assignment
    if !params.has_key?(:project_id) or !params.has_key?(:judge_email) # An error in params, likely when a user messes with the URL
      redirect_to judging_index_path, alert: 'Unable to assign judge to project. This is likely from accessing a
      broken link or refreshing a submitted form. Please try to assign the judge again, and if this fails contact an administrator.'
      return
    end

    if User.where(:email => params[:judge_email]).empty? # Make sure the email provided is valid
      redirect_to assign_judging_index_path(:project_id => params[:project_id]), alert: 'Invalid Judge Email Address.'
      return
    end

    judge_user = User.where(:email => params[:judge_email]).first
    @judge_id = judge_user.id


    if User.where(:email => params[:judge_email]).first.user_type == 'attendee' # Don't let normal attendee's judge projects
      redirect_to assign_judging_index_path(:project_id => params[:project_id]), alert: 'Error: Desired judge\'s account does not have sufficient permissions (they are a participant!).'

    elsif ((!params.has_key?(:tag) or params[:tag] == '') and JudgingAssignment.exists?(:user_id => judge_user.id, :project_id => params[:project_id], :tag => nil)) or (params.has_key?(:tag) and JudgingAssignment.exists?(:user_id => judge_user.id, :project_id => params[:project_id], :tag => params[:tag])) # If the judge is already assigned to this project.
      redirect_to assign_judging_index_path(:project_id => params[:project_id]), alert: 'Error: ' + params[:judge_email] + ' is already assigned to judge this project!'
    else
      # All is well, assign judge to project
      if params.has_key?(:tag) and params[:tag] != ''
        @assignment = JudgingAssignment.new(:user_id => judge_user.id, :project_id => params[:project_id], :tag => params[:tag])
      else
        @assignment = JudgingAssignment.new(:user_id => judge_user.id, :project_id => params[:project_id])
      end
      if @assignment.save
        redirect_to assign_judging_index_path(:project_id => params[:project_id]), notice: 'Successfully assigned judge to project.'
      else
        redirect_to assign_judging_index_path(:project_id => params[:project_id]), alert: 'Unable to assign judge to project.'
      end
    end
  end

  # GET route for mass judging assignment
  def mass_assign
    @assignments = []
  end

  # POST route for assignment validation
  def mass_submit
    puts "time to die"

    errors = []
    success = []

    mass_entries = params['entry']

    mass_entries.each do |entry|
      if User.where(:email => entry['judge_email']).empty? or Project.where(:title => entry['project_name']).empty?
        errors << "Existance: #{entry['judge_email']} or #{entry['project_name']} doesn't exist"
        next
      end

      user = User.where(:email => entry['judge_email']).first()
      project = Project.where(:title => entry['project_name']).first()
      if JudgingAssignment.exists?(user_id: user.id, project_id: project.id)
        errors << "Duplicate: #{entry['judge_email']} and #{entry['project_name']} already exists"
        next
      end

      @assignment = JudgingAssignment.new(:user_id => user.id, :project_id => project.id, :tag => entry['tag_name'])
      @assignment.save
      success << "Assignment for #{entry['judge_email']} and #{entry['project_name']} successfully created"
    end

    if errors.length() == 0
      redirect_to judge_mass_assign_judging_index_path, notice: "#{success.length()} Assignments has been successfully assigned"
    else
      redirect_to judge_mass_assign_judging_index_path, notice: "#{success.length()} Assignments has been successfully assigned", alert: "#{errors.length()} Errors - #{errors.join(" | ")}"
    end
  end


  # POST route to unassign a judge from a project
  def remove_judge_assignment
    if !params.has_key?(:project_id) or !params.has_key?(:judge_id) # An error in params, likely when a user messes with the URL
      redirect_to judging_index_path, alert: 'Unable to remove judge from project. This is likely from accessing a
      broken link or refreshing a submitted form. Please try to remove the judge again, and if this fails contact an administrator.'

    elsif !JudgingAssignment.exists?(:user_id => params[:judge_id], :project_id => params[:project_id]) # If no records match. When/if a user tries to change URL/request
      redirect_to assign_judging_index_path(:project_id => params[:project_id]), alert: 'Unable to remove assignment: The judge is not assigned to that project!'

    else
      # All is correct, remove judge from project
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
    unless params.has_key?(:project_id)
      redirect_to judging_index_path, alert: 'Error: Unable to load judging page. Please ensure that the link is valid and try again.'
    end

    if params[:tag].nil? or params[:tag] == ''
      tag = nil
    else
      tag = params[:tag]
    end

    @editing = false

    @tag = tag
    @judgement = Judgement.new
    @judgement.custom_scores = {}

    @project = Project.find_by(id: params[:project_id])
    @project_id = params[:project_id]

    if JudgingAssignment.exists?(:user_id => current_user.id, :project_id => params[:project_id], :tag => tag)
      @assignment = JudgingAssignment.find_by(:user_id => current_user.id, :project_id => params[:project_id], :tag => tag)
    else
      @assignment = nil
      unless current_user.user_type == 'admin' or current_user.user_type == 'organizer'
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

    if JudgingAssignment.exists?(:user_id => current_user.id, :project_id => judging_score_params[:project_id], :tag => @tag)
      @assignment = JudgingAssignment.find_by(:user_id => current_user.id, :project_id => judging_score_params[:project_id], :tag => @tag)
    else
      @assignment = nil
      unless current_user.user_type == 'admin' or current_user.user_type == 'organizer'
        redirect_to judging_index_path, alert: 'Error: You may not judge a project that hasn\'t been assigned to you.'
        return
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
      redirect_to new_judging_path(:judgement => @judgement, :project_id => judging_score_params[:project_id], :tag => @tag), alert: 'Error: Unable to judge project. Please ensure all fields have a value.'
    end
  end

  # GET route to show the edit form for a judgement
  def edit
    if !params.has_key?(:id)
      redirect_to judging_index_path, alert: 'Error: Unable to load judging edit page.'
    end

    @judgement = Judgement.find_by(id: params[:id])

    @editing = true


    if current_user.is_admin? or current_user.is_organizer?
      puts "organizer/admin override edit"
    elsif @judgement.user_id != current_user.id
      redirect_to judging_index_path, alert: 'You cannot edit a judgement that is not yours.'
    end

    @tag = @judgement.tag
    params[:tag] = @tag

    @project = Project.find_by(id: @judgement.project_id)
    @project_id = @judgement.project_id
  end


  # PATCH route to update judgement
  def update
    @existing_judgement = Judgement.find_by(id: params[:id])
    if current_user.is_admin? or current_user.is_organizer?
      puts "organizer override"
    elsif @existing_judgement.user_id != current_user.id
      redirect_to judging_index_path, alert: 'The judgement you are editing is not yours.'
    end

    total_score = 0

    HackumassWeb::Application::JUDGING_CUSTOM_FIELDS.each do |c|
      total_score += judging_score_params['custom_scores'][c['name']].to_f
    end

    @existing_judgement.score = total_score


    if @existing_judgement.update(judging_score_params)
      redirect_to judgement_path(params[:id]), notice: 'The judgement was successfully edited.'
    else
      @judgement = @existing_judgement
      @editing = true
      @tag = @judgement.tag
      params[:tag] = @tag

      @project = Project.find_by(id: @judgement.project_id)
      @project_id = @judgement.project_id
      render :edit
    end

  end

  # GET route for showing a specific judgement by id
  # Piggybacks off of results but for a specific judge only
  def show
    @score = Judgement.find_by(id: params[:id])
    if current_user.is_admin? or current_user.is_organizer?
      puts "organizer override"
    elsif @score.user_id != current_user.id
      redirect_to judging_index_path, alert: 'The judgement you are viewing is not yours.'
    end

    @max_score = 0
    @field_max_scores = {}
    HackumassWeb::Application::JUDGING_CUSTOM_FIELDS.each do |c|
      @max_score += c['max']
      @field_max_scores[c['name']] = c['max']
    end
  end


  # POST route to remove a score from a project
  def destroy
    unless current_user.is_admin? or current_user.is_organizer?
      redirect_to judging_index_path, alert: 'Error: You do not have permission to delete this score.'
      return
    end

    judgement = Judgement.find_by(:id => params[:judgement_id])

    @assignment = judgement
    @project_id = judgement.project.id
    @assignment.destroy
    respond_to do |format|
      format.html { redirect_to results_judging_index_path(:project_id => @project_id), notice: 'Score successfully deleted!' }
      format.json { head :no_content }
    end
  end

  # GET route for assigning a judge to all projects going for a prize
  def tag_assign

  end

  # POST route for assigning a judge to all projects going for a prize
  def add_judge_to_tag
    if !params.has_key?(:prize_criteria) or !params.has_key?(:judge_email) # An error in params, likely when a user messes with the URL
      redirect_to judging_index_path, alert: 'Unable to assign judge to prize category. This is likely from accessing a broken link or refreshing a submitted form. Please try to assign the judge again, and if this fails contact an administrator.'
      return
    elsif User.where(:email => params[:judge_email]).empty? # Make sure the email provided is valid
      redirect_to tag_assign_judging_index_path, alert: 'Error: Invalid Judge Email Address.'
      return
    elsif
      Prize.where(:criteria => params[:prize_criteria]).empty? # Make sure the prize name provided is valid
      redirect_to tag_assign_judging_index_path, alert: 'Error: Invalid Prize Name.'
      return
    end

    judge_user = User.where(:email => params[:judge_email]).first
    @judge_id = judge_user.id
    @prize = Prize.where(:criteria => params[:prize_criteria]).first

    if User.where(:email => params[:judge_email]).first.user_type == 'attendee' # Don't let normal attendee's judge projects
      redirect_to tag_assign_judging_index_path, alert: 'Error: Desired judge\'s account does not have sufficient permissions (they are a participant!).'
    end

    # All is well, assign judge to project
    @assignments = []
    count = 0
    Project.all.each do |project|
      if project.prizes.include?(@prize.criteria)
        newAssignment = JudgingAssignment.new(:user_id => judge_user.id, :project_id => project.id, :tag => params[:prize_criteria])
        newAssignment.save
        @assignments << newAssignment
        count = count + 1
      end
    end

    redirect_to tag_assign_judging_index_path, notice: 'Successfully assigned judge to ' + count.to_s + ' ' + 'project'.pluralize(count)
  end


  def assign_tables
    unless current_user.is_admin?
      redirect_to judging_index_path, alert: 'You do not have permission to perform this action.'
    end

    if params[:force]
      puts "forcing assign tables"
    elsif check_feature_flag?($project_submissions)
      redirect_to judging_index_path, alert: 'WARNING: Project submissions are still open. Cannot assign table numbers.'
      return
    elsif Project.where.not(table_id: nil).count > 0
      redirect_to judging_index_path, alert: 'WARNING: A project exists with a table number. Unassign tables first.'
      return
    end

    start = 1

    Project.where(power: [false, nil]).each do |p|
      p.table_id = start
      p.save
      start += 1
    end

    Project.where(power: true).each do |p|
      p.table_id = start
      p.save
      start += 1
    end

    redirect_to judging_index_path, notice: 'Table numbers successfully assigned to all projects!'
  end

  def unassign_tables
    unless current_user.is_admin?
      redirect_to judging_index_path, alert: 'You do not have permission to perform this action.'
      return
    end

    Project.all.each do |p|
      p.table_id = nil
      p.save
    end

    redirect_to judging_index_path, notice: 'Removed table numbers from all projects'

  end


  # GET, shows all of the judging results for a given project id
  def results
    unless params.has_key?(:project_id)
      redirect_to judging_index_path, alert: 'Error: Unable to load results for project. Please ensure that the link is valid and try again.'
    end
    @project = Project.find_by(id: params[:project_id])
    @scores = Judgement.where(project_id: @project.id)

    @max_score = 0
    @field_max_scores = {}
    HackumassWeb::Application::JUDGING_CUSTOM_FIELDS.each do |c|
      @max_score += c['max']
      @field_max_scores[c['name']] = c['max']
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

  # Never trust parameters from the scary internet
  def judging_score_params
    custom_scores_items = []
    HackumassWeb::Application::JUDGING_CUSTOM_FIELDS.each do |c|
      custom_scores_items << c['name'].to_sym
    end

    params.require(:judgement).permit(:project_id, :tag, custom_scores: custom_scores_items)
  end

end
