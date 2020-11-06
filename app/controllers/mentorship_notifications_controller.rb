class MentorshipNotificationsController < ApplicationController
  before_action :set_mentorship_notification, only: [:show, :edit, :update, :destroy]

  # GET /mentorship_notifications
  # GET /mentorship_notifications.json
  def index
    unless current_user.is_organizer?
      redirect_to index_path, error: 'No permission'
    end
    @mentorship_notifications = MentorshipNotification.all
  end

  # GET /mentorship_notifications/1
  # GET /mentorship_notifications/1.json
  def show
    unless current_user.is_organizer? or @mentorship_notification.user_id == current_user.id
      redirect_to index_path, error: 'No permission'
    end
  end

  # GET /mentorship_notifications/new
  def new
    unless current_user.is_organizer? or current_user.is_mentor?
      redirect_to index_path, error: 'No permission'
    end
    if MentorshipNotification.where(user_id: current_user.id).count > 0
      redirect_to edit_mentorship_notification_path(MentorshipNotification.where(user_id: current_user.id).first.id)
    end
    @mentorship_notification = MentorshipNotification.new
  end

  # GET /mentorship_notifications/1/edit
  def edit
    unless current_user.is_organizer? or @mentorship_notification.user_id == current_user.id
      redirect_to index_path, error: 'No permission'
    end
  end

  # POST /mentorship_notifications
  # POST /mentorship_notifications.json
  def create
    unless current_user.is_organizer? or current_user.is_mentor?
      redirect_to index_path, error: 'No permission'
    end

    @mentorship_notification = MentorshipNotification.new(mentorship_notification_params)

    @mentorship_notification.user_id = current_user.id

    respond_to do |format|
      if @mentorship_notification.save
        format.html { redirect_to mentorship_requests_path, notice: 'Mentorship notification was successfully created.' }
        format.json { render :show, status: :created, location: @mentorship_notification }
      else
        format.html { render :new }
        format.json { render json: @mentorship_notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mentorship_notifications/1
  # PATCH/PUT /mentorship_notifications/1.json
  def update
    unless current_user.is_organizer? or @mentorship_notification.user_id == current_user.id
      redirect_to index_path, error: 'No permission'
    end
    
    respond_to do |format|
      if @mentorship_notification.update(mentorship_notification_params)
        if HackumassWeb::Application::SLACK_ENABLED
          if @mentorship_notification.all
            slack_notify_user(@mentorship_notification.user.slack_id, "You just updated your mentorship request notification preferences. You will be notified for all mentorship requests. Thanks! (Make sure you turn off Slack do not disturb mode and enable notifications!)")
          else
            slack_notify_user(@mentorship_notification.user.slack_id, "You just updated your mentorship request notification preferences. You will be notified for mentorship requests with these tech categories: #{@mentorship_notification.tech}. Thanks! (Make sure you turn off Slack do not disturb mode and enable notifications!)")
          end
        end
        format.html { redirect_to mentorship_requests_path, notice: 'Mentorship notification was successfully updated.' }
        format.json { render :show, status: :ok, location: @mentorship_notification }
      else
        format.html { render :edit }
        format.json { render json: @mentorship_notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mentorship_notifications/1
  # DELETE /mentorship_notifications/1.json
  def destroy

    unless current_user.is_organizer? or @mentorship_notification.user_id == current_user.id
      redirect_to index_path, error: 'No permission'
    end

    @mentorship_notification.destroy
    respond_to do |format|
      format.html { redirect_to mentorship_requests_path, notice: 'Mentorship notification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mentorship_notification
      @mentorship_notification = MentorshipNotification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mentorship_notification_params
      params.require(:mentorship_notification).permit(:user_id, :all, tech: [])
    end
end
