class PagesController < ApplicationController
  before_action :check_permissions, only: [:add_permissions, :remove_permissions, :admin]
  before_action :is_feature_enabled, only: :check_in
  # allows autocomplete to work on the email field in user and creates a route through pages,
  # :full => true means that the string searched will look for the match anywhere in the "email" string, and not just the beginning
  autocomplete :user, :email, :full => true

  def index

    if !user_signed_in?
      respond_to do |format|
        format.html{redirect_to new_user_session_path}
      end
    end

    @all_apps_count = EventApplication.all.count
    @accepted_count = EventApplication.where(status: 'accepted').count
    @waitlisted_count = EventApplication.where(status: 'waitlisted').count
    @undecided_count = EventApplication.where(status: 'undecided').count
    @denied_count = EventApplication.where(status: 'denied').count
    @flagged_count = EventApplication.where(flag: true).count
    @user_count = User.all.count
    @hardware_count = HardwareItem.all.count

    @hardware_checkouts = current_user.hardware_checkouts
    @upcoming_events = Event.all.order(time: :asc).limit(4)

    @project_count = Project.all.count
    @prize_count = Prize.all.count
    @event_count = Event.all.count

    qrcode = RQRCode::QRCode.new(current_user.email)
    @qr_image = qrcode.as_png(
          resize_gte_to: false,
          resize_exactly_to: false,
          fill: 'white',
          color: 'black',
          size: 280,
          border_modules: 4,
          module_px_size: 6,
          file: nil )
  end

  def admin
    @all_admins = User.where(user_type: 'admin')
    @all_organizers = User.where(user_type: 'organizer')
    @all_mentors = User.where(user_type: 'mentor')
  end

  def join_slack
  end

  def check_in
    @check_in_count = User.where(check_in: true).count
    @rsvp_count = User.where(rsvp: true).count

    user_email = params[:email]
    unless user_email.nil? #Only validate for an email when the email is in the params

      if user_email.empty?
        flash[:alert] = 'Error! Cannot check in user without an email.'
        return
      end

      user_email = user_email.downcase.delete(' ')

      user = User.where(:email => user_email).first
      if user.nil?
        redirect_to check_in_path, alert: "Error! Couldn't find user with email: #{user_email}"
        return
      end

      if user.event_application.status != 'accepted'
        redirect_to check_in_path, alert: "Error! Couldn't check in user with email: #{user_email}. This user has NOT been accepted to the event."
        return
      end

      user.check_in = true
      if user.save
        redirect_to check_in_path, notice: "#{user.full_name.titleize} has been checked in successfully"
        return
      end

    end

  end



  def add_permissions
    # Check if the user doing this is admin
      if params[:add_admin].present?
        @user = User.where(email: params[:add_admin]).first
        if @user.nil?
          redirect_to admin_path, alert: "Could not find user with email #{params[:add_admin]}"
        else
          @user.user_type = 'admin'
          @user.save
          redirect_to admin_path, notice: "#{params[:add_admin]} is now an admin"
        end
      end

      if params[:add_organizer].present?
        @user = User.where(email: params[:add_organizer]).first
        if @user.nil?
          redirect_to admin_path, alert: "Could not find user with email #{params[:add_organizer]}"
        else
          @user.user_type = 'organizer'
          @user.save
          redirect_to admin_path, notice: "#{params[:add_organizer]} is now an organizer"
        end
      end

      if params[:add_mentor].present?
        @user = User.where(email: params[:add_mentor]).first
        if @user.nil?
          redirect_to admin_path, alert: "Could not find user with email #{params[:add_mentor]}"
        else
          @user.user_type = 'mentor'
          @user.save
          redirect_to admin_path, notice: "#{params[:add_mentor]} is now a mentor"
        end
      end
  end

  def remove_permissions
    @user = User.find(params[:format])
    if @user.email == 'bramirez@umass.edu'
      redirect_to admin_path, alert: "Permission could not be removed. Brian is God."
    else
      @user.user_type = 'attendee'
      @user.save
      redirect_to admin_path, notice: 'Permission has been removed'
    end
  end

  def is_invalid_email?(email)
    !(email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
  end

  def is_feature_enabled
    feature_flag = FeatureFlag.find_by(name: 'check_in')
    # Redirect user to index if no feature flag has been found
    if feature_flag.nil?
      redirect_to index_path, notice: 'Check In is currently not available. Try again later!'
    else
      if feature_flag.value == false
        # Redirect user to index if feature flag is off (false)
        redirect_to index_path, alert: 'Check In is currently not available. Try again later!'
      end
    end
  end

  def rsvp
    current_user.rsvp = true
    current_user.save
    flash[:success] = "You Successfully RSVP'd for the Event"
    redirect_to root_path
  end

  def unrsvp
    current_user.rsvp = false
    current_user.save
    current_user.event_application.status = 'denied'
    current_user.event_application.save(:validate => false)
    UserMailer.denied_email(current_user).deliver_now
    flash[:success] = "You Successfully cancelled your participation in the event. Sorry to see you go..."
    redirect_to root_path
  end

  private

  # Only admin is allowed to be in admin pages
  def check_permissions
    unless current_user.is_admin?
      redirect_to index_path, alert: 'You do not have the permissions to visit the admin page'
    end
  end
end
