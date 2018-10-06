class MentorshipRequestsController < ApplicationController
  before_action :set_mentorship_request, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, only: [:destroy, :edit, :new]
  # before_action :is_feature_enabled

  def index

    @search = MentorshipRequest.ransack(params[:q])

    @mentorship_requests = @search.result.paginate(page: params[:page], per_page: 10)
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
    @mentorship_request.status = 'Waiting'

    if @mentorship_request.save
      redirect_to index_path, notice: 'Your mentorship request was successfully created. Now, Head out to the mentorship table!'
    else
      render :new
    end
  end

  def update
    if @mentorship_request.update!(mentorship_request_params)
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
      request.status = 'Resolved'
      request.save!

      flash[:success] = 'Request Successfully Resolved'
      redirect_to mentorship_requests_path
  end

  def mark_as_denied
    request = MentorshipRequest.find(params[:mentorship_request])
    request.status = 'Denied'
    request.save!

    flash[:success] = 'Request Successfully denied'
    redirect_to mentorship_requests_path
  end

  def message_on_slack
    request = MentorshipRequest.find(params[:mentorship_request])
    slack_id = User.find(request.user_id).get_slack_id
    if slack_id
      request.status = "Contacted"
      request.save
      redirect_to "https://hackumassvi.slack.com/messages/" + slack_id
    else
      redirect_to request, alert: 'This user is not signed up on slack.'
    end
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
      params.require(:mentorship_request).permit(:user_id, :mentor_id, :title, :status, :urgency,  :description, :screenshot, tech:[])
    end

    def check_permissions
      unless current_user.is_admin? or current_user.is_mentor? or current_user.number_of_requests < 5
        redirect_to index_path, alert: 'You do not have the permissions to visit this section of mentorship'
      end
    end

end
