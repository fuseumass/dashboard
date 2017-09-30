namespace :reminder do
  desc "reminder email to all applicants that they haven't finish their
  application and the deadline is coming up"

  task :send_email => :environment do
    UserMailer.reminder_email(User.all).deliver_now;
  end

end
