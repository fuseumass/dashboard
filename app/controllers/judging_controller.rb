class JudgingController < ApplicationController
  before_action -> { is_feature_enabled($Judging) }
  before_action :auth_user

  def index
    @assigned = Project.joins(:judgement).where("judgements.project_id = projects.id AND judgements.user_id = ?","%#{current_user.id}%")
    @projects = Project.all.paginate(page: params[:page], per_page: 20)
    @scores = Judgement.all
  end

  def new
    @judgement = Judgement.new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

    # Only admin, organizers, and mentors are allowed to judge projects
    def check_permissions
      unless current_user.is_organizer? or current_user.is_mentor? or current_user.is_admin?
        redirect_to index_path, alert: 'You do not have permission to access judging.'
      end
    end
end
