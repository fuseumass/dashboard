class JudgingController < ApplicationController
  before_action -> { is_feature_enabled($Judging) }
  before_action :auth_user

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
    @assigned = Project.joins(:judgement).where("judgements.user_id" => current_user.id)
    @projects = Project.all.paginate(page: params[:page], per_page: 20)
    @scores = Judgement.all
  end

  def new
    @judgement = Judgement.new
  end

  def create
    if(!params.has_key?(:project_id) or !params.has_key?(:email))
      redirect_to judging_index_path, alert: 'Unable to assign judge to project. This is likely from accessing a 
      broken link or refreshing a submitted form. Please try to assign the judge again, 
      and if this fails contact an administrator.'
      return
    elsif (User.where(:email => params[:email]).empty?)
      redirect_to new_judging_path(:project_id => params[:project_id], :project_title => params[:project_title]), alert: 'Invalid Judge Email Address.'
    else
      @judge_id = User.where(:email => params[:email]).first.id
      @assignment = Judgement.new(:user_id => @judge_id, :project_id => params[:project_id], :score => -1)

      if @assignment.save
        redirect_to judging_index_path, notice: 'Successfully assigned judge to project.'
      else
        redirect_to new_judging_path(:project_id => params[:project_id], :project_title => params[:project_title]), alert: 'Unable to assign judge to project.'
      end
    end
  end

  def show
  end

  def edit
  end

  def update
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
end
