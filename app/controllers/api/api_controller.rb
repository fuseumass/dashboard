module Api
  class Api::ApiController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  skip_before_action :auth_user
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  end

  def index
    render json: {}
  end
end
end
