class EventApplicationsController < ApplicationController
  before_action :set_event_application, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, only: [:index, :show, :destory, :edit]

  def index
    @event_applications = EventApplication.all
  end

  def show
  end

  def new
    if EventApplication.where(user_id: current_user.id).any?
        redirect_to event_applications_path
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

  def destroy
    @event_application.destroy
    respond_to do |format|
      format.html { redirect_to event_applications_url, notice: 'Event application was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_application
      @event_application = EventApplication.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_application_params
      params.require(:event_application).permit(:name, :university, :major, :grad_year, :email, :phone, :resume, :t_shirt, :linkedin,
                                                :github, :previous_hackathon_attendance, :transportation, :waiver_liability_agreement,
                                                :challengepost_username, :do_you_have_a_team, :how_did_you_hear_about_hackumass,
                                                :are_you_interested_in_hardware_hacks, :age, :sex, :future_hardware_for_HackUMass,
                                                :food_restrictions, :food_restrictions_text, :team_name, :transportation_from_where,
                                                :programming_skills_other_field, programming_skills_list:[], type_of_programmer_list:[],
                                                interested_hardware_list:[])
    end

    def check_permissions
      if user_signed_in?
        unless current_user.is_admin? or current_user.is_organizer?
          redirect_to new_user_session_path, alert: 'You do not have the permissions to visit this section of the website'
        end
      else
        redirect_to new_user_session_path
      end
    end
end
