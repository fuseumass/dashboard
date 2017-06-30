class EventApplicationsController < ApplicationController
  before_action :set_event_application, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, only: [:index, :show, :destroy, :edit, :status_updated, :update]
  

  # updates the application status of the applicants  
  def status_updated
    @new_status = params[:new_status]
    @id = params[:id]
    @application = EventApplication.find_by(user_id: @id)
    @application.application_status = @new_status
    @application.save
    redirect_to event_application_path(@application)
  end
    

  def index
    @event_applications = EventApplication.all
  end

  def show
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
      if @event_application.save
        redirect_to @event_application, notice: 'Event application was successfully created.'
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


  def edit
  end


  def create
    @event_application = EventApplication.new(event_application_params)
    @event_application.user = current_user
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_application
      @event_application = EventApplication.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_application_params
      params.require(:event_application).permit(:name, :email, :phone, :age, :sex, :university, :major, :grad_year,
                                                :food_restrictions, :food_restrictions_info, :t_shirt,
                                                :resume, :linkedin, :github, :previous_hackathon_attendance,
                                                :transportation, :transportation_location,:interested_in_hardware_hacks,
                                                :how_did_you_hear_about_hackumass, :future_hardware_for_hackumass,
                                                :waiver_liability_agreement, interested_hardware_hacks_list:[],
                                                programmer_type_list:[], programming_skills_list:[])
    end

    # Only admins and organizers have the ability to all permission except delete and edited
    # No one should have the ability to delete or edit but to be on the safe side we are still going to check those permission
    def check_permissions
      if user_signed_in?
        unless current_user.is_admin? or current_user.is_organizer?
          redirect_to index_path, alert: 'Sorry, but you seem to lack the permission to go to that part of the website.'
        end
      else
        redirect_to new_user_session_path
      end
    end
end
