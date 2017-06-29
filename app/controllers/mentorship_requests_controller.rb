class MentorshipRequestsController < ApplicationController
  before_action :set_mentorship_request, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, only: [:destroy, :edit]


  def index
    @mentorship_requests = MentorshipRequest.all
  end


  def show
  end

  def new
    @mentorship_request = MentorshipRequest.new
  end

  def edit
  end

  def create
    @mentorship_request = MentorshipRequest.new(mentorship_request_params)
    @mentorship_request.user = current_user
    @mentorship_request.status = 'pending'

    if @mentorship_request.save
      redirect_to @mentorship_request, notice: 'Mentorship request was successfully created.'
    else
      render :new
    end
  end

  def update
    if @mentorship_request.update(mentorship_request_params)
      redirect_to @mentorship_request, notice: 'Mentorship request was successfully updated.'
    else
      render :edit
    end
  end


  def destroy
    @mentorship_request.destroy
    redirect_to mentorship_requests_url, notice: 'Mentorship request was successfully destroyed.'
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
        unless current_user.is_admin? or current_user.is_mentor?
          redirect_to index_path, alert: 'You do not have the permissions to visit this section of mentorship'
        end
      else
        redirect_to new_user_session_path
      end
    end

end
