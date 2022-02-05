class PagesController < ApplicationController
  before_action :check_permissions, only: [:add_permissions, :remove_permissions, :permissions]
  before_action -> { is_feature_enabled($CheckIn) }, only: :check_in
  before_action :check_organizer_permissions, only: :check_in

  def index

    if !user_signed_in?
      respond_to do |format|
        format.html{redirect_to new_user_session_path}
      end
    end

    if CustomRsvp.where(user_id: @current_user.id).exists?
      @rsvp = CustomRsvp.where(user_id: @current_user.id).first
      @rsvp_new = false
    else
      @rsvp = CustomRsvp.new
      @rsvp_new = true
    end

    # Stuff used for Admin Page
    @all_apps_count = EventApplication.all.count
    @accepted_count = EventApplication.where(status: 'accepted').count
    @waitlisted_count = EventApplication.where(status: 'waitlisted').count
    @undecided_count = EventApplication.where(status: 'undecided').count
    @denied_count = EventApplication.where(status: 'denied').count
    @flagged_count = EventApplication.where(flag: true).count
    @user_count = User.all.count
    @hardware_count = HardwareItem.all.count
    @hardware_checkouts_count = HardwareCheckout.all.count
    @mentorship_requests_count = MentorshipRequest.all.count
    @checked_in_user_count = User.where(check_in: true).count
    @applications_count = User.where(user_type: 'attendee').where.not(event_application: nil).count
    @rsvp_user_count = User.where(rsvp: true).count

    @hardware_checkouts = current_user.hardware_checkouts
    @upcoming_events = Event.where("end_time > ?", Time.now).order(start_time: :asc).limit(5)
    @latest_requests = MentorshipRequest.order(created_at: :desc).limit(5)

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

  # GET route for permission mangement page
  def permissions
    @all_admins = User.where(user_type: 'admin')
    @all_organizers = User.where(user_type: 'organizer')
    @all_mentors = User.where(user_type: 'mentor')
  end

  def join_slack
  end


  def check_in_self

    user_email = params[:email]
    unless user_email.nil? #Only validate for an email when the email is in the params

      if user_email.empty?
        flash[:alert] = 'Error! Cannot check in user without an email.'
        return
      end

      user_email = user_email.downcase.delete(' ')

      user = User.where(:email => user_email).first

      unless params[:force_check_in]
        if user.event_application
          if user.event_application.status != 'accepted'
            redirect_to root_path, alert: "Error! Couldn't self-check in #{user_email}."
            return
          end
        else
          redirect_to root_path, alert: "Error! Couldn't check in user #{user_email}. You have not applied to the event."
          return
        end
      end

      user.check_in = true

      if user.save
        redirect_to root_path, notice: "Congrats #{user.full_name.titleize}! You have successfully checked in virtually!"
        return
      end

    end
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

      unless params[:force_check_in]
        if user.event_application
          if user.event_application.status != 'accepted'
            redirect_to check_in_path, alert: "Error! Couldn't check in user with email: #{user_email}. This user has NOT been accepted to the event. To override, select force check in."
            return
          end
        else
          redirect_to check_in_path, alert: "Error! Couldn't check in user with email: #{user_email}. This user has NOT applied to the event. To override, select force check in."
          return
        end
      else
        flash[:alert] = "Forcibly checked in #{user_email}"
      end

      user.check_in = true
      if user.save
        redirect_to check_in_path, notice: "#{user.full_name.titleize} has been checked in successfully."
        # if user.is_host_student?
        #   redirect_to check_in_path, notice: "This participant is a #{HackumassWeb::Application::CHECKIN_UNIVERSITY_NAME} student. #{user.full_name.titleize} has been checked in successfully."
        # else
        #   redirect_to check_in_path, notice: "***THIS PARTICIPANT IS A NON-#{HackumassWeb::Application::CHECKIN_UNIVERSITY_NAME} STUDENT.*** #{user.full_name.titleize} has been checked in successfully. "
        # end
        return
      end

    end

  end



  def add_permissions
    # Check if the user doing this is admin
      if params[:add_admin].present?
        @user = User.where(email: params[:add_admin]).first
        if @user.nil?
          redirect_to permissions_path, alert: "Could not find user with email #{params[:add_admin]}"
        else
          @user.user_type = 'admin'
          @user.save
          redirect_to permissions_path, notice: "#{params[:add_admin]} is now an admin"
        end
      end

      if params[:add_organizer].present?
        @user = User.where(email: params[:add_organizer]).first
        if @user.nil?
          redirect_to permissions_path, alert: "Could not find user with email #{params[:add_organizer]}"
        else
          @user.user_type = 'organizer'
          @user.save
          redirect_to permissions_path, notice: "#{params[:add_organizer]} is now an organizer"
        end
      end

      if params[:add_mentor].present?
        @user = User.where(email: params[:add_mentor]).first
        if @user.nil?
          redirect_to permissions_path, alert: "Could not find user with email #{params[:add_mentor]}"
        else
          @user.user_type = 'mentor'
          @user.save
          redirect_to permissions_path, notice: "#{params[:add_mentor]} is now a mentor"
        end
      end
  end

  def remove_permissions
    @user = User.find(params[:format])
    if @user.is_admin? and User.where(user_type: "admin").length == 1 
      redirect_to permissions_path, alert: "Unable to remove permissions. There must be at least 1 administrator."
    else
      @user.user_type = 'attendee'
      @user.save
      redirect_to permissions_path, notice: 'Permission has been removed'
    end
  end

  def is_invalid_email?(email)
    !(email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
  end

  def unrsvp
    current_user.rsvp = false
    current_user.save
    crsvp = CustomRsvp.where(user_id: current_user.id)
    if crsvp.length == 1
      crsvp[0].destroy
    end
    unless current_user.event_application
      flash[:error] = "You can't un-RSVP if you never applied to the event!"
    else
      current_user.event_application.status = 'denied'
      current_user.event_application.save(:validate => false)
      UserMailer.denied_email(current_user).deliver_now
      flash[:success] = "You Successfully cancelled your participation in the event. Sorry to see you go..."
    end
    redirect_to root_path
  end

  # GET for redeem code page
  def redeem_code
    # Just renders page
  end

  # POST for submitting code
  def use_code
    if (current_user.rsvp or current_user.check_in) and current_user.user_type == 'attendee'
      redirect_to redeem_code_path, alert: 'Error: You do not have permission to use this code. If you believe this to be in error, please contact an organizer.'
    elsif HackumassWeb::Application::CODES.key?(params[:code].downcase)  # If a valid code
      new_role = HackumassWeb::Application::CODES[params[:code].downcase]
      current_user.user_type = new_role
      current_user.save
      redirect_to index_path, notice: 'Successfully Redeemed Code!'
    else
      redirect_to redeem_code_path, alert: 'Error: Invalid code provided.'
    end
  end

  private

  # Only admin is allowed to be in admin pages
  def check_permissions
    unless current_user.is_admin?
      redirect_to index_path, alert: 'You do not have the permissions to visit the admin page'
    end
  end

  def check_organizer_permissions
    unless current_user.is_organizer?
      redirect_to index_path, alert: 'You are not an admin or organizer.'
    end
  end
end
