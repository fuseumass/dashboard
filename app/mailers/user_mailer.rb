class UserMailer < ApplicationMailer
  #TODO: Change Email Address
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
    if user.event_application.age.to_i < 18
      attachments['HUMVLiabilityWaivers.pdf'] = File.read('app/assets/attachments/HUMVLiabilityWaivers.pdf')
    end
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

end
