class JudgingController < ApplicationController
  before_action -> { is_feature_enabled($Judging) }
  before_action :auth_user


  def index
    @assigned = Project.joins(:judgement).where("judgements.project_id = projects.id AND judgements.user_id = ?","%#{current_user.id}%")
    @projects = Project.all.paginate(page: params[:page], per_page: 20)
    @scores = Judgement.all
  end


  def show
    redirect_to 'index_path'
  end


  def new
    @judgement = Judgement.new
  end


  def edit
  end


  def create
    @score = Judgement.new(judging_params)
  end

  def update
    if @score.update(judging_params)
        redirect_to @score, notice: 'Project Rating Successfully Updated.'
    else
      render :edit
    end
  end

  def destroy
    @score.destroy
      redirect_to judging_url, notice: 'Project Rating Successfully Deleted.'
  end

  private

    # Only admins and organizers have the ability to create, update, edit, show, and destroy hardware items
    def check_permissions
      unless current_user.is_organizer? or current_user.is_mentor? or current_user.is_admin?
        redirect_to index_path, alert: 'You do not have the permissions for judging.'
      end
    end

end
