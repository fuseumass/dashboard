class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    additional_params = [:first_name, :last_name]
    devise_parameter_sanitizer.permit(:sign_up, keys: additional_params)
    devise_parameter_sanitizer.permit(:account_update, keys: additional_params)
  end
end
