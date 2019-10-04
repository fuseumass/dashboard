class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, except: :index
  before_action -> { is_feature_enabled($Events) }
  def index
    if current_user and current_user.is_attendee? and !current_user.has_slack?
        redirect_to join_slack_path, alert: 'You will need to join slack before you access our events page.'
    end
    @all_events = Event.all.order(start_time: :asc)
    @events = Event.where("end_time > ?", Time.now).order(start_time: :asc).paginate(page: params[:page], per_page: 10)
  end

  def show
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

  def add_user
    begin
      @event = Event.find(params[:event_id])
      @user = User.find(params[:user_id])
    rescue => exception
      redirect_to events_url, alert: 'Unable to RSVP for event.'
      return
    end

    @event_attendance = EventAttendance.new({:user_id => @user.id, :event_id => @event.id})
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
    @event.destroy
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
    end
end
