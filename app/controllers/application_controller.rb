class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :auth_user
  before_action :set_raven_context
  autocomplete :university, :name, :full => true
  autocomplete :major, :name, :full => true

  # Additional parameters needed for devise
  protected
  def configure_permitted_parameters
    additional_params = [:first_name, :last_name, :type]
    devise_parameter_sanitizer.permit(:sign_up, keys: additional_params)
    devise_parameter_sanitizer.permit(:account_update, keys: additional_params)
  end

  # Automatically re-route user to login except when user is loging in or signing up or hardware api call or event api Call
  def auth_user
    unless user_signed_in? or self.request.path == new_user_session_path or self.request.path == new_user_registration_path or self.request.path == hardware_items_path(:json) or self.request.path == events_path(:json) 
      redirect_to new_user_session_path
    end
  end
  private
  def set_raven_context
    Raven.user_context(id: session[:current_user_id])
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end 
end

