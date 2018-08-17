class MentorshipRequestsController < ApplicationController
  before_action :set_mentorship_request, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, only: [:destroy, :edit]
  before_action :is_feature_enabled

  def index
    @mentorship_requests = MentorshipRequest.all.order(created_at: :desc)
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
      redirect_to index_path, notice: 'Your mentorship request was successfully created. Now, Head out to the mentorship table!'
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

  def mark_as_resolved
      request = MentorshipRequest.find(params[:mentorship_request])
      request.status = 'resolved'
      request.save!

      flash[:success] = 'Request Successfully Resolved'
      redirect_to mentorship_requests_path
  end

  def mark_as_denied
    request = MentorshipRequest.find(params[:mentorship_request])
    request.status = 'denied'
    request.save!

    flash[:success] = 'Request Successfully denied'
    redirect_to mentorship_requests_path
  end

  def is_feature_enabled
    feature_flag = FeatureFlag.find_by(name: 'mentorship_requests')
    # Redirect user to index if no feature flag has been found
    if feature_flag.nil?
      redirect_to index_path, notice: 'Mentorship is currently not available. Try again later'
    else
      if feature_flag.value == false
        # Redirect user to index if no feature flag is off (false)
        redirect_to index_path, alert: 'Mentorship is currently not available. Try again later'
      end
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
      unless current_user.is_admin? or current_user.is_mentor?
        redirect_to index_path, alert: 'You do not have the permissions to visit this section of mentorship'
      end
    end

end
