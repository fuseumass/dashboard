namespace :admissions do
  desc "Accept or flag student applications"
  task accept_now: :environment do

    list_of_apps = EventApplication.where(:application_status => 'undecided')

    flagged_count = 0
    accepted_count = 0
    counter = 0

    list_of_apps.each do |app|

          # Get rejected if you graduated early or left shit empty on the application.
          if app.transportation or app.university == 'N/A' or app.major == 'N/A' or app.grad_year == '2016' or app.grad_year == '2015' or app.grad_year == '2014'
            # app.flag = true
            # app.save(:validate => false)
            # flagged_count += 1
          else
            app.application_status = 'accepted'
            app.save(:validate => false)
            accepted_count += 1
            UserMailer.accepted_email(app.user).deliver_now
          end
          counter += 1

          if counter >= 300
            break
          end

    end #End of event application check


    puts "Flagged Applications: #{flagged_count}"
    puts "Accepted Applications: #{accepted_count}"
    puts "Total Applications Considered: #{flagged_count+accepted_count}"
  end

end
