class EventApplicationsController < ApplicationController
  # imports helper methods to the controller
  include EventApplicationsHelper

  before_action -> { is_feature_enabled($Applications) }
  before_action :set_event_application, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, only: [:index, :destroy, :status_updated]
  autocomplete :university, :name, full: true
  autocomplete :major, :name, full: true

  def index
    @all_apps_count = EventApplication.all.count
    @accepted_count = EventApplication.where(status: 'accepted').count
    @waitlisted_count = EventApplication.where(status: 'waitlisted').count
    @undecided_count = EventApplication.where(status: 'undecided').count
    @denied_count = EventApplication.where(status: 'denied').count
    @flagged_count = EventApplication.where(flag: true).count
    @rsvp_count = EventApplication.joins(:user).where(users: {rsvp: true}).count

    @flagged = params[:flagged]
    @status = params[:status]
    if ['undecided', 'accepted', 'denied', 'waitlisted'].include?(@status)
      @applications = EventApplication.where({status: @status})
    elsif params[:flagged].present?
      @applications = EventApplication.where(flag: true)
    elsif params[:rsvp].present?
      @applications = EventApplication.joins(:user).where(users: {rsvp: true})
    else
      @applications = EventApplication.all
    end
    @applications = @applications.order(created_at: :asc)
    @posts = @applications.paginate(page: params[:page], per_page: 20)

    @appsCSV = EventApplication.all


    @check_in_chart = User.where(:check_in => true).group_by_day(:updated_at).count
    total = 0
    @check_in_chart.keys.each do |k|
      total += @check_in_chart[k]
      @check_in_chart[k] = total
    end

    @reg_chart = User.all.group_by_day(:created_at).count
    total = 0
    @reg_chart.keys.each do |k|
      total += @reg_chart[k]
      @reg_chart[k] = total
    end

    @app_chart = EventApplication.all.group_by_day(:created_at).count
    total = 0
    @app_chart.keys.each do |k|
      total += @app_chart[k]
      @app_chart[k] = total
    end

    @rsvp_chart = User.where(:rsvp => true).group_by_day(:updated_at).count
    total = 0
    @rsvp_chart.keys.each do |k|
      total += @rsvp_chart[k]
      @rsvp_chart[k] = total
    end


    respond_to do |format|
      format.html
      format.csv { send_data @appsCSV.to_csv, filename: "event_applications.csv" }
    end

  end


  def show
    # variable used in erb file
    @applicant = @application
    @status = @application.status
    @user = @application.user

    unless current_user.is_organizer?
      if @user != current_user
        redirect_to index_path, alert: lack_permission_msg if !admin_or_organizer? && @user != current_user
      end
    end
  end

  def new
    if @event_application_mode == 'closed'
      redirect_to index_path
      flash[:error] = "Error: Event Registrations are Currently Closed."
      return
    end

    @application = EventApplication.new

    if current_user.has_applied?
        redirect_to index_path
        flash[:error] = "Error: You Have Already Created a Registration."
    end

  end


  def edit
  end


  def create
    puts "params: #{event_application_params}"
    puts "cfields params: #{event_application_params['custom_fields']}"
    @application = EventApplication.new(event_application_params)
    @application.user = current_user
    if @event_application_mode == 'open'
      @application.status = 'undecided'
    elsif @event_application_mode == 'waitlist'
      @application.status = 'waitlisted'
    else
      @application.status = 'denied'
    end

    if @application.save
      redirect_to index_path, notice: 'Thank you for submitting your registration!'
    else
      render :new
    end
  end

  def update
    @application = @application
    if @application.update(event_application_params)
      redirect_to @application, notice: 'Event registration was successfully updated.'
    else
      render :edit
    end
  end


  def destroy
    @application.destroy
    redirect_to event_applications_url, notice: 'Event registration was successfully destroyed.'
  end

  def search
    @all_apps_count = EventApplication.all.count
    @accepted_count = EventApplication.where(status: 'accepted').count
    @waitlisted_count = EventApplication.where(status: 'waitlisted').count
    @undecided_count = EventApplication.where(status: 'undecided').count
    @denied_count = EventApplication.where(status: 'denied').count
    @flagged_count = EventApplication.where(flag: true).count

    @flagged = params[:flagged]
    @status = params[:status]
    if ['undecided', 'accepted', 'denied', 'waitlisted'].include?(@status)
      @applications = EventApplication.where({status: @status})
    elsif params[:flagged].present?
      @applications = EventApplication.where(flag: true)
    elsif params[:rsvp].present?
      @applications = EventApplication.joins(:user).where(users: {rsvp: true})
    else
      @applications = EventApplication.all
    end

    if params[:search].present?
      @applications = @applications.joins(:user).where("lower(users.first_name) LIKE lower(?) OR
                                                    lower(users.last_name) LIKE lower(?) OR
                                                    lower(users.email) LIKE lower(?) OR
                                                    lower(major) LIKE lower(?) OR
                                                    lower(name) LIKE lower(?) OR
                                                    lower(university) LIKE lower(?) OR
                                                    lower(status) LIKE lower(?) OR
                                                    lower(education_lvl) LIKE lower(?)",
                                              "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%",
                                              "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%",
                                              "%#{params[:search]}%", "%#{params[:search]}%")
      @posts = @applications.paginate(page: params[:page], per_page: 20)
    else
      redirect_to event_applications_path
    end
  end

  # updates the application status of the applicants.
  def status_updated
    new_status = params[:new_status]
    id = params[:id]
    application = EventApplication.find_by(user_id: id)
    application.status = new_status
    application.save(:validate => false)
    flash[:success] = "Status successfully updated."

    redirect_to event_application_path(application)



    # Send email when status changes.
    if new_status == 'accepted'
      UserMailer.accepted_email(application.user).deliver_now
    elsif new_status == 'denied'
      UserMailer.denied_email(application.user).deliver_now
    else
      UserMailer.waitlisted_email(application.user).deliver_now
    end
  end

  def flag_application
    app_id = params[:application]
    app = EventApplication.find(app_id)
    app.flag = true
    app.save(:validate => false)

    flash[:success] = "Application successfully flagged"

    redirect_to event_application_path(app)
  end

  def unflag_application
    app_id = params[:application]
    app = EventApplication.find(app_id)
    app.flag = false
    app.save(:validate => false)
    flash[:success] = "Flag successfully removed"

    redirect_to event_application_path(app)
  end

  # GET route to show change event application mode page
  def application_mode
    if !FeatureFlag.find_by(name: 'application_mode').nil?
      # Note: @event_application_mode is automatically updated in Application Controller
      @current_mode = @event_application_mode
    else
      @current_mode = 'ERROR'
    end
  end

  # POST route to set the current event application mode
  def set_application_mode
    if !current_user.is_admin?
      redirect_to event_applications_path, alert: 'Error: You do not have permission to change event application modes.'
    else
      if !params[:mode].present?
        redirect_to application_mode_event_applications_path, alert: 'Error: Invalid Parameters Provided (1) If you get this message, please try to refresh the page and try again.'
      else
        if params[:mode] == 'open'
          @flag = FeatureFlag.find_by(name: 'application_mode')
          @flag.description = 'open'
          @flag.save
          redirect_to application_mode_event_applications_path, notice: 'Successfully set registration mode to open!'
        elsif params[:mode] == 'waitlist'
          @flag = FeatureFlag.find_by(name: 'application_mode')
          @flag.description = 'waitlist'
          @flag.save
          redirect_to application_mode_event_applications_path, notice: 'Successfully set registration mode to waitlist!'
        elsif params[:mode] == 'closed'
          @flag = FeatureFlag.find_by(name: 'application_mode')
          @flag.description = 'closed'
          @flag.save
          redirect_to application_mode_event_applications_path, notice: 'Successfully closed event registrations!'
        else
          redirect_to application_mode_event_applications_path, alert: 'Error: Invalid Parameters Provided (2). If you get this message, please try to refresh the page and try again.'
        end
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event_application
    begin
      @application = EventApplication.find(params[:id])
    rescue
      redirect_to event_applications_path, error: 'Error: Unable to load desired page. Please ensure the URL is valid and try again.'
    end
  end

  def event_application_params
    custom_fields_items = []
    HackumassWeb::Application::EVENT_APPLICATION_CUSTOM_FIELDS.each do |c|
      if c['type'] == 'multiselect'
        custom_fields_items << {c['name'].to_sym => []}
      else
        custom_fields_items << c['name'].to_sym
      end
    end
    params.require(:event_application).permit(:name, :phone, :age, :gender, :university, :major, :grad_year,
                   :food_restrictions, :food_restrictions_info, :resume, :t_shirt_size, :education_lvl,
                   :waiver_liability_agreement, :mlh_agreement, :mlh_communications,
                   custom_fields: custom_fields_items)
  end

  # Only admins and organizers have the ability to all permission except delete.
  def check_permissions
    redirect_to index_path, alert: lack_permission_msg unless admin_or_organizer?
  end
end
