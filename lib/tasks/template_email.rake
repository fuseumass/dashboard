namespace :template_email do

  task :send => :environment do
    email_count = 0

    # all_checkouts = HardwareCheckout.all
    # all_checkouts.each do |checkout|
    #   if checkout.user.has_slack? == false
    #     UserMailer.template_email(user, 'URGENT Slack Needed For Hardware').deliver_now
    #     email_count++
    #   end
    # end
    # puts "Emails sent: #{email_count}"
  end

end
