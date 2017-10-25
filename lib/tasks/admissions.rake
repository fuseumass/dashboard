namespace :admissions do
  desc "Accept or flag student applications"
  task accept_now: :environment do

    list_of_apps = EventApplication.where(:application_status => 'waitlisted')
    flagged_count = 0
    accepted_count = 0

    list_of_apps.each do |app|

      app.application_status = 'accepted'
      app.save(:validate => false)
      accepted_count += 1
      UserMailer.accepted_email(app.user).deliver_now

    end #End of event application check


    puts "Flagged Applications: #{flagged_count}"
    puts "Accepted Applications: #{accepted_count}"
    puts "Total Applications Considered: #{flagged_count+accepted_count}"
  end

end
