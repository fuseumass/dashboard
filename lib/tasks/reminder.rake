namespace :reminder do
  desc "reminder email to all applicants that they haven't finish their
  application and the deadline is coming up"

  task :send_email => :environment do
    @all_user = User.all
    count = 0
    if @all_user.any?
      @all_user.each do |user|
        if user.event_application == nil
          UserMailer.reminder_email(user).deliver_now;
          puts 'Email sent to ' + user.email
          count += 1
        end
      end
    end
    puts '------------------------------------------------------------'
    puts "Total emails sent: #{count}"
  end

end
