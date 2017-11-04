namespace :reminder do
  desc "reminder email to all applicants that they haven't finish their
  application and the deadline is coming up"


  task :send_email => :environment do
    @apps = EventApplication.where(rsvp: true).where(check_in: false)
    counter = 0
    @apps.each do |app|
      if counter >= 100
        break
      end

      app.check_in = true
      app.save(:validate => false)
      counter += 1

    end

    puts "Total Emails sent: #{counter}"
  end

end
