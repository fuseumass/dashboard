class UserMailer < ApplicationMailer

  default from: 'donotreply.hackumass@gmail.com'

  def welcome_email(user)
    @user = user;
    mail(to: @user.email, subject: 'Thank you for signing up for HackUMass V!')
  end

  def submit_email(user)
    @user = user;
    mail(to: @user.email, subject: 'Thank you for submitting your HackUMass V application!')
  end

  def accepted_email(user)
    @user = user;
    attachments['HUMVLiabilityWaivers.pdf'] = File.read('app/assets/attachments/HUMVLiabilityWaivers.pdf')
    mail(to: @user.email, subject: 'Congratulations! Welcome to HackUMass V!')
  end

  def denied_email(user)
    @user = user;
    mail(to: @user.email, subject: 'HackUMass V Application Status Update')
  end

  def waitlisted_email(user)
    @user = user;
    mail(to: @user.email, subject: 'HackUMass V Application Status Update')
  end

  def reminder_email(user, message, subject)
    @user = user
    @message = message
    @subject = subject
    mail(to: @user.email, subject: @subject)
  end

  def template_email(user, subject)
    @user = user
    @subject = subject
    mail(to: @user.email, subject: @subject)
  end

end
