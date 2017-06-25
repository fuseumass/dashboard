class MentorshipRequestsController < ApplicationController
  before_action :set_mentorship_request, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, only: [:destroy, :edit]

  def show
  end


  def new
    @mentorship_request = MentorshipRequest.new
  end


  def edit
  end


  def create
    @mentorship_request = MentorshipRequest.new(mentorship_request_params)
    @mentorship_request.user_id = current_user.id
    @mentorship_request.status = "pending"

    if @mentorship_request.save
      redirect_to @mentorship_request, notice: 'Mentorship request was successfully created.'
    else
      render :new
    end
  end


  def update
    respond_to do |format|
      if @mentorship_request.update(mentorship_request_params)
        format.html { redirect_to @mentorship_request, notice: 'Mentorship request was successfully updated.' }
        format.json { render :show, status: :ok, location: @mentorship_request }
      else
        format.html { render :edit }
        format.json { render json: @mentorship_request.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @mentorship_request.destroy
    respond_to do |format|
      format.html { redirect_to mentorship_requests_url, notice: 'Mentorship request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mentorship_request
      @mentorship_request = MentorshipRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mentorship_request_params
      params.require(:mentorship_request).permit(:user_id, :mentor_id, :title, :help_type, :status, :urgency)
    end

    def check_permissions
      if user_signed_in?
        unless current_user.is_admin? or current_user.is_organizer?
          redirect_to index_path, alert: 'You do not have the permissions to visit this section of mentorship'
        end
      else
        redirect_to new_user_session_path
      end
    end
    
end
