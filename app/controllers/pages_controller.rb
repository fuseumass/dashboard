class PagesController < ApplicationController
  before_action :check_permissions, only: [:add_permissions, :remove_permissions, :admin]
  # allows autocomplete to work on the email field in user and creates a route through pages,
  # :full => true means that the string searched will look for the match anywhere in the "email" string, and not just the beginning
  autocomplete :user, :email, :full => true

  def index

    if !user_signed_in?
      respond_to do |format|
        format.html{redirect_to new_user_session_path}
      end
    end

    @hardware_checkouts = current_user.hardware_checkouts
  end

  def admin
    @all_admins = User.where(user_type: 'admin')
    @all_organizers = User.where(user_type: 'organizer')
    @all_mentors = User.where(user_type: 'mentor')
  end

  def check_in
    user_email = params[:email]
    unless user_email.nil? #Only validate for an email when the email is in the params

      if user_email.empty?
        flash[:alert] = 'Error! Cannot check in user without an email'
        return
      end

      user_email = user_email.downcase.delete(' ')

      if is_invalid_email?(user_email)
        flash[:alert] = " Error! '#{user_email}' is not valid format for an email."
      end

      user = User.where(:email => user_email).first
      if user.nil?
        redirect_to check_in_path, alert: " Error! Couldn't find user with email: '#{user_email}'."
      end

      if not user.is_accepted?
        redirect_to check_in_path, alert: 'Error! This user has not been accepted to HackUMass V.'
      end

      if not user.did_rsvp?
        redirect_to check_in_path, alert: 'Error! This user did not RSVP for the event. #SucksToSuck'
      end

      app = user.event_application
      app.check_in = true
      app.save(:validate => false)
      redirect_to check_in_path, success: 'User has been check in successfully'
    end

  end



  def add_permissions
    # Check if the user doing this is admin
      if params[:add_admin].present?
        @user = User.where(email: params[:add_admin]).first
        if @user.nil?
          redirect_to admin_path, alert: "Could not find user with email #{params[:add_admin]}"
        else
          @user.user_type = 'admin'
          @user.save
          redirect_to admin_path, notice: "#{params[:add_admin]} is now an admin"
        end
      end

      if params[:add_organizer].present?
        @user = User.where(email: params[:add_organizer]).first
        if @user.nil?
          redirect_to admin_path, alert: "Could not find user with email #{params[:add_organizer]}"
        else
          @user.user_type = 'organizer'
          @user.save
          redirect_to admin_path, notice: "#{params[:add_organizer]} is now an organizer"
        end
      end

      if params[:add_mentor].present?
        @user = User.where(email: params[:add_mentor]).first
        if @user.nil?
          redirect_to admin_path, alert: "Could not find user with email #{params[:add_mentor]}"
        else
          @user.user_type = 'mentor'
          @user.save
          redirect_to admin_path, notice: "#{params[:add_mentor]} is now a mentor"
        end
      end
  end

  def remove_permissions
    @user = User.find(params[:format])
    @user.user_type = 'attendee'
    @user.save
    redirect_to admin_path, notice: 'Permission has been removed'
  end

  def is_invalid_email?(email)
    !(email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
  end

  private

  # Only admin is allowed to be in admin pages
  def check_permissions
    unless current_user.is_admin?
      redirect_to index_path, alert: 'You do not have the permissions to visit the admin page'
    end
  end
end
