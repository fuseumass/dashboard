class MentorshipRequestsController < ApplicationController
  before_action :set_mentorship_request, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, only: [:destroy, :show]
  before_action -> { is_feature_enabled($MentorshipRequests) }



  def search
    if params[:search].present?
      if params[:sortby] == "urgency"
        if params[:asc] == "true"
          @mentorship_requests = MentorshipRequest.search(params[:search], page: params[:page], per_page: 20, order: {urgency: :asc})
        else
          @mentorship_requests = MentorshipRequest.search(params[:search], page: params[:page], per_page: 20, order: {urgency: :desc})
        end
        # Sort and display requests by urgency
      elsif params[:sortby] == "created_at"
        if params[:asc] == "true"
          @mentorship_requests = MentorshipRequest.search(params[:search], page: params[:page], per_page: 20, order: {created_at: :asc})
        else
          @mentorship_requests = MentorshipRequest.search(params[:search], page: params[:page], per_page: 20, order: {created_at: :desc})
        end
        # Sort and display requests by when created
      else
        @mentorship_requests = MentorshipRequest.search(params[:search], page: params[:page], per_page: 20)
      end
      # Display 20 mentorship requests on page
    else
      redirect_to mentorship_requests_path
    end
  end

  def index

    if params[:sortby]
      if params[:asc] == "true"
        @mentorship_requests = MentorshipRequest.all.order(params[:sortby] + " ASC")
      else
        @mentorship_requests = MentorshipRequest.all.order(params[:sortby] + " DESC")
      end

    else
      @mentorship_requests = MentorshipRequest.all
    end

    if current_user.is_attendee? or current_user.is_mentor?
      if !current_user.has_slack?
        redirect_to join_slack_path, alert: 'You will need to join slack before you access our mentorship page.'
      end
    end
    # Redirect to join slack page if user isn't on slack
    @mentorship_requests = @mentorship_requests.paginate(page: params[:page], per_page: 15)
  end


  def show
  end

  def new
    if current_user.number_of_requests >= 5
      redirect_to mentorship_requests_path, alert: 'You have 5 unresolved requests. You need to resolve at least one of them to submit another one.'
    end
    @mentorship_request = MentorshipRequest.new
  end
  # Create new mentorship request if user has under 5 unresolved requests

  def edit
    if @mentorship_request.user != current_user
      redirect_to mentorship_requests_path, alert: 'You cannot edit a mentorship request that is not yours.'
    end
  end
  # Block edits on mentorship requests of other users

  def create
    @mentorship_request = MentorshipRequest.new(mentorship_request_params)
    @mentorship_request.user = current_user
    @mentorship_request.status = 'Waiting'

    if @mentorship_request.save
      redirect_to mentorship_requests_path, notice: 'Mentorship request successfully created. A mentor should slack you soon. Otherwise, go to the mentorship table.'
    else
      render :new # New mentorship request if previous is unsuccessful 
    end
  end
  # Create new mentorship request and flash good message if successful 

  def update
    if @mentorship_request.update!(mentorship_request_params)
      redirect_to mentorship_requests_path, notice: 'Mentorship request was successfully updated.'
    else
      render :edit
    end
  end
  # Edit and update mentorship request


  def destroy
    @mentorship_request.destroy
    redirect_to mentorship_requests_url, notice: 'Mentorship request was successfully destroyed.'
  end
  # Permanently delete mentorship request

  def mark_as_resolved
      request = MentorshipRequest.find(params[:mentorship_request])
      request.status = 'Resolved'
      request.save!

      flash[:success] = 'Request Successfully Resolved'
      redirect_to mentorship_requests_path
  end
  # Mark request status as resolved

  def mark_as_denied
    request = MentorshipRequest.find(params[:mentorship_request])
    request.status = 'Denied'
    request.save!

    flash[:success] = 'Request Successfully Denied'
    redirect_to mentorship_requests_path
  end
  # Mark request status as denied

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
  # Contact user on slack and mark request status to contacted

<<<<<<< HEAD
  def is_feature_enabled
    feature_flag = FeatureFlag.find_by(name: 'mentorship_requests')
    # Redirect user to index if no feature flag has been found
    if feature_flag.nil?
      redirect_to index_path, notice: 'Mentorship is currently not available. Try again later.'
    else
      if feature_flag.value == false
        # Redirect user to index if feature flag is off (false)
        redirect_to index_path, alert: 'Mentorship is currently not available. Try again later.'
      end
    end
  end

=======
>>>>>>> 0883b54d9326168c1eab64b84d29ce180215f1e2
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mentorship_request
      @mentorship_request = MentorshipRequest.find(params[:id])
    end

    # Check parameters to ensure only whitelisted ones are able to be passed through.
    def mentorship_request_params
      params.require(:mentorship_request).permit(:user_id, :mentor_id, :title, :status, :urgency,  :description, :screenshot, tech:[])
    end

    def check_permissions
      unless current_user.is_admin? or current_user.is_mentor? or current_user.is_organizer?
        redirect_to mentorship_requests_path, alert: 'You do not have the permissions to visit this section of mentorship.'
      end
    end

end
