namespace :reminder do
  desc "reminder email to all applicants that they haven't finish their
  application and the deadline is coming up"


  task :send_email => :environment do

    @users = User.where(email: "ryan@umass.edu")
    count = 0

    @users.each do |user|
      if user.has_applied? == false
        UserMailer.reminder_email(user,'Applications are closing soon!', "It looks like you haven’t submitted your application yet! The deadline for HackUMass VI is September 24th, so if you’re still interested in being part of the largest hackathon in Western Mass, please submit your application soon. We hope to see you this fall~").deliver_now
        count += 1
      end
    end

    puts "#{count} emails sent succesfully!"

  end

end
