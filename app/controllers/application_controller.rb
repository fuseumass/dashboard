# The main controller for the entire Rails application. For the most
# part the application controller contain all the miscalleous methods
# and or any method that need to be seen throughout the entire application
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :auth_user
  before_action :set_raven_context
  after_action  :set_access_control_headers
  autocomplete :university, :name, full: true
  autocomplete :major, :name, full: true


  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = 'hackumass.com'
  end

  # Automatically re-route user to login except when user is logging in or
  # signing up or hardware api call or event api call
  def auth_user
    redirect_to new_user_session_path unless user_is_authenticated?
  end

  protected

  # Additional parameters needed for devise
  def configure_permitted_parameters
    additional_params = %i[first_name last_name type]
    devise_parameter_sanitizer.permit(:sign_up, keys: additional_params)
    devise_parameter_sanitizer.permit(:account_update, keys: additional_params)
  end

  private

  # This method configure sentry so that is capture the user id of the user being
  # affected and the url that that is causing this problem.
  def set_raven_context
    Raven.user_context(id: session[:current_user_id])
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  # A helper method for 'auth_user'. This method returns a boolean that checks
  # whether if a user is logging in or signing up or calling a hardware api or
  # event api.
  def user_is_authenticated?
    controllers = %w[passwords sessions]
    paths = [new_user_registration_path, hardware_items_path(:json), events_path(:json)]
    user_signed_in? || controllers.include?(controller_name) || paths.include?(request.path)
  end
end
