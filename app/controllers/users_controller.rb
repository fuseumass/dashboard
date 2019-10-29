class UsersController < ApplicationController
  before_action :authenticate_user!

  def go_to_forgot
    current_user.send_reset_password_instructions
    sign_out current_user
    flash[:notice] = "Send an email to you"
    redirect_to index_path
  end
end