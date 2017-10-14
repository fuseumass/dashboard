class EventApplicationsController < ApplicationController
  before_action :set_event_application, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, only: [:index, :destroy, :status_updated]
  autocomplete :university, :name, :full => true
  autocomplete :major, :name, :full => true

  def index
    @all_apps_count = EventApplication.all.count
    @accepted_count = EventApplication.where(application_status: 'accepted').count
    @waitlisted_count = EventApplication.where(application_status: 'waitlisted').count
    @undecided_count = EventApplication.where(application_status: 'undecided').count
    @denied_count = EventApplication.where(application_status: 'denied').count
    @flagged_count = EventApplication.where(flag: true).count

    @flagged = params[:flagged]
    @status = params[:status]
    if ['undecided', 'accepted', 'denied', 'waitlisted'].include?(@status)
      @applications = EventApplication.where({application_status: @status})
    elsif params[:flagged].present?
      @applications = EventApplication.where(flag: true)
    else
      @applications = EventApplication.all
    end
    @applications = @applications.order(created_at: :asc)
    @posts = @applications.paginate(page: params[:page], per_page: 20)

  end

  def show
    unless current_user.is_admin? or current_user.is_organizer?
      if @event_application.user != current_user
        redirect_to index_path, alert: 'Sorry, but you seem to lack the permission to go to that part of the website.'
      end
    end
  end

  def new
    if current_user.has_applied?
        redirect_to index_path
        flash[:error] = "You have already created an application."
    end
    @event_application = EventApplication.new
  end


  def edit
  end


  def create
    @event_application = EventApplication.new(event_application_params)
    @event_application.user = current_user
    @event_application.application_status = 'waitlisted'
    if @event_application.save
      redirect_to index_path, notice: 'Thank you for submitting your application!'
    else
      render :new
    end
  end

  def update
    if @event_application.update(event_application_params)
      redirect_to @event_application, notice: 'Event application was successfully updated.'
    else
      render :edit
    end
  end


  def destroy
    @event_application.destroy
    redirect_to event_applications_url, notice: 'Event application was successfully destroyed.'
  end

  def search
    @all_apps_count = EventApplication.all.count
    @accepted_count = EventApplication.where(application_status: 'accepted').count
    @waitlisted_count = EventApplication.where(application_status: 'waitlisted').count
    @undecided_count = EventApplication.where(application_status: 'undecided').count
    @denied_count = EventApplication.where(application_status: 'denied').count
    @flagged_count = EventApplication.where(flag: true).count

    if params[:search].present?
      @posts = EventApplication.search(params[:search])
    else
      redirect_to event_applications_path
    end
  end

  # updates the application status of the applicants
  def status_updated
    new_status = params[:new_status]
    id = params[:id]
    application = EventApplication.find_by(user_id: id)
    application.application_status = new_status
    application.save
    flash[:success] = "Status successfully updated."

    redirect_to event_application_path(application)



    # Send email when status changes
    if new_status == 'accepted'
      UserMailer.accepted_email(application.user).deliver_now
    elsif new_status == 'denied'
      UserMailer.denied_email(application.user).deliver_now
    else
      UserMailer.waitlisted_email(application.user).deliver_now
    end
  end

  def flag_application
    appId = params[:application]
    app = EventApplication.find(appId)
    app.flag = true
    app.save(:validate => false)

    flash[:success] = "Application successfully flagged"

    redirect_to event_application_path(app)
  end

  def unflag_application
    appId = params[:application]
    app = EventApplication.find(appId)
    app.flag = false
    app.save(:validate => false)
    flash[:success] = "Flag successfully removed"

    redirect_to event_application_path(app)
  end

  def rsvp
    @app = current_user.event_application
    @app.rsvp = true
    @app.save
    flash[:success] = "You Successfully RSVP for the Event"
    redirect_to root_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_application
      begin
        @event_application = EventApplication.find(params[:id])
      rescue
        flash[:warning] = 'Upppps looks like you went backwards or forward too much.'
        redirect_to event_applications_path
        return
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_application_params
      params.require(:event_application).permit(:name, :email, :phone, :age, :sex, :university, :major, :grad_year,
                                                :food_restrictions, :food_restrictions_info, :t_shirt,
                                                :resume, :linkedin, :github, :previous_hackathon_attendance,
                                                :transportation, :transportation_location,:interested_in_hardware_hacks,
                                                :how_did_you_hear_about_hackumass, :future_hardware_for_hackumass,
                                                :waiver_liability_agreement, interested_hardware_hacks_list:[],
                                                programming_skills_list:[], hardware_skills_list:[])
    end

    # Only admins and organizers have the ability to all permission except delete
    def check_permissions
      unless current_user.is_admin? or current_user.is_organizer?
        redirect_to index_path, alert: 'Sorry, but you seem to lack the permission to go to that part of the website.'
      end
    end
end
