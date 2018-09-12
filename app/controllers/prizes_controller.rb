class PrizesController < ApplicationController
  before_action :set_prize, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, only: [:show, :new, :edit]
  before_action :is_feature_enabled

  def index
    @prizes = Prize.all.order(priority: :desc)
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
      redirect_to @prize, notice: 'Prize was successfully created.'
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

  def is_feature_enabled
    feature_flag = FeatureFlag.find_by(name: 'prizes')
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
    def set_prize
      @prize = Prize.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prize_params
      params.require(:prize).permit(:name, :description, :criteria, :sponsor, :priority)
    end

    def check_permissions
      unless current_user.is_admin? or current_user.is_organizer?
        redirect_to index_path, alert: 'You do not have the permissions to visit this section of prizes'
      end
    end
end
