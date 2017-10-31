namespace :template_email do



  task :send => :environment do
    email_count = 0

    app_mailing_list = EventApplication.where(:rsvp => true)

    app_mailing_list.each do |app|
      UserMailer.template_email(app.user, 'UPDATED HackUMass Participant Information',).deliver_now
      email_count += 1
    end

    puts '--------------------------'
    puts "Number of emails sent: #{email_count}"
  end

end
