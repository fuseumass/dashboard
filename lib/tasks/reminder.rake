namespace :reminder do
  desc "reminder email to all applicants that they haven't finish their
  application and the deadline is coming up"

  count = 0
  task :send_email => :environment do
    @apps = EventApplication.where(:application_status => 'accepted' ).where(:rsvp => false)
    @apps.each do |app|
      UserMailer.reminder_email(app.user).deliver_now
      count += 1
    end

    puts '------------------------------------------------------------'
    puts "Total emails sent: #{count}"
  end

end
