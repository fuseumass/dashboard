class EventApplicationsController < ApplicationController
  before_action :set_event_application, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, only: [:index, :show, :destory, :edit]

  # GET /event_applications
  # GET /event_applications.json
  def index
    @event_applications = EventApplication.all
  end

  # GET /event_applications/1
  # GET /event_applications/1.json
  def show
  end

  # GET /event_applications/new
  def new
    if EventApplication.where(user_id: current_user.id).any?
        redirect_to event_applications_path
        flash[:error] = "You have already created an application."
    end
    @event_application = EventApplication.new
  end

  # GET /event_applications/1/edit
  def edit
  end

  # POST /event_applications
  # POST /event_applications.json
  def create
    @event_application = EventApplication.new(event_application_params)
    @event_application.user_id = current_user.id

    respond_to do |format|
      if @event_application.save
        format.html { redirect_to @event_application, notice: 'Event application was successfully created.' }
        format.json { render :show, status: :created, location: @event_application }
      else
        format.html { render :new }
        format.json { render json: @event_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /event_applications/1
  # PATCH/PUT /event_applications/1.json
  def update
    respond_to do |format|
      if @event_application.update(event_application_params)
        format.html { redirect_to @event_application, notice: 'Event application was successfully updated.' }
        format.json { render :show, status: :ok, location: @event_application }
      else
        format.html { render :edit }
        format.json { render json: @event_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_applications/1
  # DELETE /event_applications/1.json
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
