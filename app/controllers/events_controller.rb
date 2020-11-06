class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, except: :index
  before_action -> { is_feature_enabled($Events) }
  def index
    if HackumassWeb::Application::SLACK_ENABLED and current_user and current_user.is_attendee? and !current_user.has_slack?
        redirect_to join_slack_path, alert: 'You will need to join slack before you access our events page.'
    end
    if session[:return_to]
        redirect_to session.delete(:return_to)
    end
    @all_events = Event.all.order(start_time: :asc)
    @events = Event.where("end_time > ?", Time.now).order(start_time: :asc, id: :asc).paginate(page: params[:page], per_page: 10)
    
    respond_to do |format|
      format.html
      format.json { render json: @all_events }
      format.csv { 
        if current_user.is_admin? or current_user.is_organizer? 
          send_data @all_events.to_csv, filename: "events.csv" 
        else 
          redirect_to index_path, alert: 'You do not have the permissions to visit the admin page'
        end
      }
    end
      
  end
  
  def show
    @check_in_count = EventAttendance.where(event_id: @event.id, checked_in: true).count
    @rsvp_count = EventAttendance.where(event_id: @event.id).count
    session[:return_to] = request.referer
  end

  def new
    @event = Event.new
  end


  def edit
  end

  def create
    @event = Event.new(event_params)
    @event.created_by = current_user.full_name

    if @event.save
      redirect_to events_path, notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  def check_in
    @event = Event.find(params[:event_id])
    user_email = params[:email]
    unless user_email.nil? #Only validate for an email when the email is in the params
      if user_email.empty?
        flash[:alert] = 'Error! Cannot check in user without an email.'
        return
      end

      user_email = user_email.downcase.delete(' ')

      user = User.where(:email => user_email).first
      if user.nil?
        redirect_to @event, alert: "Error! Couldn't find user with email: #{user_email}"
        return
      end

      if user.event_application
        if user.event_application.status != 'accepted'
          redirect_to @event, alert: "Error! Couldn't check in user with email: #{user_email}. This user has NOT been accepted to the event."
          return
        end
      else
        redirect_to @event, alert: "Error! Couldn't check in user with email: #{user_email}. This user has NOT applied to the event."
        return
      end
      if params[:force_check_in]
        begin
          @event_attendance = EventAttendance.find_by(event_id: @event.id, user_id: user.id)
        rescue => exception
          @event_attendance = EventAttendance.new({:user_id => user.id, :event_id => @event.id})
          @event_attendance.checked_in = true
          @event_attendance.save()
          redirect_to @event, alert: "Forced user #{user.email} into event"
          return
        end
        if @event_attendance.nil?
          @event_attendance = EventAttendance.new({:user_id => user.id, :event_id => @event.id})
          @event_attendance.checked_in = true
          @event_attendance.save()
          redirect_to @event, alert: "Forced user #{user.email} into event"
          return
        else 
          @event_attendance.checked_in = true
          @event_attendance.save()
          redirect_to @event, alert: "Forced user #{user.email} into event"
        end
      else
        begin
          @event_attendance = EventAttendance.find_by(event_id: @event.id, user_id: user.id)
        rescue => exception
          redirect_to @event, alert: "User #{user.email} did not RSVP"
          return
        end
        if @event_attendance.nil?
          redirect_to @event, alert: "User #{user.email} did not RSVP"
          return
        end
        @event_attendance.checked_in = true
        if @event_attendance.save
          redirect_to @event, notice: "#{user.full_name.titleize} has been checked in successfully"
          return
        end
      end
    end
  end

  def add_user
    begin
      @event = Event.find(params[:event_id])
      @user = User.find(params[:user_id])
    rescue => exception
      redirect_to events_url, alert: 'Unable to RSVP for event.'
      return
    end

    @event_attendance = EventAttendance.new({:user_id => @user.id, :event_id => @event.id})
    @event_attendance.checked_in = false
    @event_attendance.save()

    redirect_to events_path, notice: 'Successfully RSVP\'d!'
  end

  def remove_user
    begin
      @event = Event.find(params[:event_id])
      @user = User.find(params[:user_id])
    rescue => exception
      redirect_to events_url, alert: 'Unable to UnRSVP for event.'
      return
    end

    @event_attendance = EventAttendance.find_by(user_id: @user.id, event_id: @event.id)
    @event_attendance.destroy()

    redirect_to events_path, notice: 'Successfully UnRSVP\'d!'
  end

  def destroy
    @event.users.each do |user|
      @event_attendance = EventAttendance.find_by(user_id: user.id, event_id: @event.id)
      @event_attendance.destroy()
    end
    @event.destroy()
    redirect_to events_url, notice: 'Event was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:title, :description, :location, :start_time, :end_time, :host, :created_by, :thumbnail, :image, :max_seats, :rsvpable)
    end

    #  Only admins and organizers have the ability to create, update, edit, and destroy Events
    #  Everyone else can view.
    def check_permissions
      unless current_user.is_admin?
        redirect_to index_path, alert: 'You do not have the permissions to visit the admin page'
      end
    end
end
