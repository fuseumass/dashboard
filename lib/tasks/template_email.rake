namespace :template_email do



  task :send => :environment do
    email_count = 0

    app_mailing_list = EventApplication.(:rsvp => true)

    app_mailing_list.each do |app|
      UserMailer.template_email(app, 'Important HackUMass Check-In Information',).deliver_now
      email_count += 1
    end

    puts '--------------------------'
    puts "Number UMass students that didn't rsvp: #{email_count}"
  end

end
