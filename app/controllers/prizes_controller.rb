class PrizesController < ApplicationController
  before_action :set_prize, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, only: [:show, :new, :edit]


  def index
    @prizes = Prize.all
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

    respond_to do |format|
      if @prize.save
        redirect_to @prize, notice: 'Prize was successfully created.'
      else
        render :new
      end
    end
  end

  def update
    respond_to do |format|
      if @prize.update(prize_params)
        redirect_to @prize, notice: 'Prize was successfully updated.'
      else
        render :edit
      end
    end
  end

  # DELETE /prizes/1
  # DELETE /prizes/1.json
  def destroy
    @prize.destroy
    respond_to do |format|
      redirect_to prizes_url, notice: 'Prize was successfully destroyed.'
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
