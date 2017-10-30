namespace :reminder do
  desc "reminder email to all applicants that they haven't finish their
  application and the deadline is coming up"


  task :send_email => :environment do
    @brian = User.find(1)

    UserMailer.reminder_email(@brian, test, 'Test subject').deliver_now
  end

end
