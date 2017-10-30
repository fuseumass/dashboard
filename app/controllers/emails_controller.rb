class EmailsController < ApplicationController
  before_action :set_email, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions
  def index
    @emails = Email.all
  end


  def show
  end


  def new
    @email = Email.new
  end


  def edit
  end


  def create
    @email = Email.new(email_params)
    @email.sent_by = current_user.full_name
    @email.status = 'Not Sent'

    if @email.save
        redirect_to @email, notice: 'Email was successfully created.'
    else
        render :new
    end
  end

  def update
    if @email.update(email_params)
        redirect_to @email, notice: 'Email was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @email.destroy
      redirect_to emails_url, notice: 'Email was successfully destroyed.'
  end

  def send_email
    @email = Email.find(params[:email_id])

    if @email.nil?
      redirect_to emails_path, error: 'Error! No email found'
    end

    apps_list = set_mailing_list(@email.mailing_list)

    apps_list.each do |app|
      UserMailer.reminder_email(app.user, @email.message, @email.subject).deliver_now
    end

    @email.status = 'Sent'
    @email.save!
    redirect_to @email, notice: 'Success! The email has been delivered!'

  end

  # Returns a list of applications whose users we should sent emails to
  def set_mailing_list(list)
    if list == 'All Participants that RSVP'
      EventApplication.where(:rsvp => true)
    elsif list == 'All Checked-In Participants'
      EventApplication.where(:check_in => true)
    elsif list == 'Send Test Email to Myself'
      EventApplication.where(:user => current_user)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email
      @email = Email.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def email_params
      params.require(:email).permit(:subject, :message, :mailing_list, :status, :sent_by)
    end

    # Only admins and organizers have the ability to create, update, edit, show, and destroy hardware items
    def check_permissions
      unless current_user.is_admin?
        redirect_to hardware_items_path, alert: 'You do not have the permissions to visit this section of hardware'
      end
    end


end
