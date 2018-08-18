namespace :template_email do



  task :send => :environment do
    email_count = 0

    app_mailing_list = EventApplication.where(:check_in => true)

    app_mailing_list.each do |app|
      UserMailer.template_email(app, 'Thank you for attending HackUMass VI! <> Win an Amazon Echo Dot',).deliver_now
      email_count += 1
    end

    puts "Emails sent: #{email_count}"

  end

end
