class PrizesController < ApplicationController
  before_action :set_prize, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, only: [:show, :new, :edit, :assign, :set_prize_winner, :remove_prize_winner]
  before_action -> { is_feature_enabled($Prizes) }

  def index
    if current_user.is_attendee?
      if HackumassWeb::Application::SLACK_ENABLED and !current_user.has_slack?
        redirect_to join_slack_path, alert: 'You will need to join slack before you access prizes.'
      end
    end
    @prizes = Prize.all.order(priority: :asc)
  end

  def show
  end

  def new
    @prize = Prize.new
  end

  def edit
  end

  def create
    @prize = Prize.new(prize_params)
    if @prize.save
      redirect_to prizes_path
    else
      render :new
    end
  end

  def update
    if @prize.update(prize_params)
      redirect_to @prize, notice: 'Prize was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @prize.destroy
    redirect_to prizes_url, notice: 'Prize was successfully destroyed.'
  end

  # GET Route for marking a project as a prize winner
  def assign
    @prize = Prize.find(params[:prize_id])
    @project = nil

    Project.all.each do |p|
      if p.prizes_won.include? @prize.title
        @project = p
        break
      end
    end

  end

  # POST Route for marking a project as a prize winner
  def set_prize_winner
    project = Project.find_by(:title => params[:project_name])
    if !project
      redirect_to prize_assign_path, alert: 'Unable to assign winner, invalid project name specified.'
      return
    end

    prize = Prize.find_by(:id => params[:prize_id])

    if !prize
      redirect_to prize_assign_path, alert: 'Unable to assign winner. Prize could not be found.'
      return
    end

    project.prizes_won << prize.title
    project.save

    redirect_to prize_assign_path, notice: 'Successfully assigned winner to prize.'
  end

  # POST Route for marking a project as a prize winner
  def remove_prize_winner
    prize = Prize.find_by(:id => params[:prize_id])
    if !prize
      redirect_to prize_assign_path, alert: 'Unable to assign winner. Prize could not be found.'
      return
    end

    project = Project.find_by(:title => params[:project_name])
    if !project
      redirect_to prize_assign_path, alert: 'Unable to assign winner, invalid project name specified.'
      return
    end
    
    project.prizes_won.delete(prize.title)
    project.save

    redirect_to prize_assign_path, notice: 'Successfully removed prize from project.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prize
      @prize = Prize.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prize_params
      params.require(:prize).permit(:award, :description, :title, :sponsor, :priority, :project_selectable)
    end

    def check_permissions
      unless current_user.is_organizer?
        redirect_to index_path, alert: 'You do not have the permissions to visit this section of prizes'
      end
    end
end
