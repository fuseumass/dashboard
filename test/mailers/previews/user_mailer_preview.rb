# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  def welcome_email_preview
    @user = User.last
    UserMailer.welcome_email(@user)
  end

  def submit_email_preview
    @user = User.last
    UserMailer.submit_email(@user)
  end

  def accepted_email_preview
    @user = User.last
    UserMailer.accepted_email(@user)
  end

  def denied_email_preview
    @user = User.last
    UserMailer.denied_email(@user)
  end

  def waitlisted_email_preview
    @user = User.last
    UserMailer.waitlisted_email(@user)
  end

  def reminder_email_preivew
    @user = User.last
    UserMailer.reminder_email(@user)
  end

  def template_email_preview
    @user = User.last
    @subject = 'Test Subject 2'
    UserMailer.template_email(@user, @subject)
  end

end
