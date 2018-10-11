namespace :template_email do

  task :send => :environment do
    email_count = 0
    user_mailing_list = User.all

    user_mailing_list.each do |user|
      if user.is_accepted?
        UserMailer.template_email(user, 'Hardware, Prizes and More!').deliver_now
        email_count += 1
      end
    end
    puts "Emails sent: #{email_count}"
  end

end
