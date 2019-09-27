class CustomRsvpsController < ApplicationController

    def index
        redirect_to :index
    end

    def show
        unless admin_or_organizer?
            redirect_to :index
        end
        @rsvp = CustomRsvp.find(params[:id])
        @applicant = EventApplication.joins(:user).where(user: @rsvp.user).first
        render "custom_rsvp/show"
    end

    def list
        unless admin_or_organizer?
            redirect_to :index
        end
        render "custom_rsvp/list"
    end

    def create
        @custom_rsvp = CustomRsvp.new(custom_rsvp_params)
        @custom_rsvp.user = @current_user
        @rsvp = @custom_rsvp
        if not current_user.event_application or current_user.event_application.status != 'accepted'
            flash[:error] = "You are unable to RSVP because your application was not accepted."
            redirect_to :index
        elsif @custom_rsvp.save
            @current_user.rsvp = true
            flash[:success] = "You have successfully RSVP'd to the event! See you there!"
            redirect_to :index
            @current_user.save
        else
            flash[:error] = "You are unable to RSVP because of validation errors in your RSVP questions."
            @rsvp = @custom_rsvp
            render 'pages/index'
        end
    end

    def update
        @custom_rsvp = CustomRsvp.find(params[:id])
        @custom_rsvp = @custom_rsvp
        @rsvp = @custom_rsvp
        if @current_user.id != @custom_rsvp.user.id and not admin_or_organizer?
            redirect_to :index, notice: 'No permissions'
        elsif @custom_rsvp.update(custom_rsvp_params)
            redirect_to :index, notice: 'RSVP was successfully updated.'
        else
          render 'pages/index'
        end
      end

    def custom_rsvp_params
        answers_items = []
        exist = false
        HackumassWeb::Application::RSVP_CUSTOM_FIELDS.each do |c|
            exist = true
            if c['type'] == 'multiselect'
                answers_items << {c['name'].to_sym => []}
            else
                answers_items << c['name'].to_sym
            end
        end
        if exist
            params.require(:custom_rsvp).permit(:user_id, answers: answers_items)
        end
    end

    private
     # Use callbacks to share common setup or constraints between actions.
    def set_event_application
        begin
            @application = CustomRsvp.find(params[:id])
        rescue
            flash[:warning] = 'Unable to find that custom RSVP.'
            redirect_to :index
            return
        end
    end


    def admin_or_organizer?
        current_user.user_type == 'admin' || current_user.user_type == 'organizer'
    end

end
