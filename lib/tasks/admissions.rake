namespace :admissions do
  desc "Accept or flag student applications"
  task :update_apps, [:newFlag, :flag] => :environment do |t, args|

    list_of_apps = EventApplication.where(:status => args[:flag])
    flagged_count = 0
    accepted_count = 0

    list_of_apps.each do |app|

      app.status = args[:newFlag]
      app.save(:validate => false)
      accepted_count += 1
      UserMailer.accepted_email(app.user).deliver_now

    end #End of event application check


    puts "Flagged Applications: #{flagged_count}"
    puts "Accepted Applications: #{accepted_count}"
    puts "Total Applications Considered: #{flagged_count+accepted_count}"
  end

  desc "Accept or flag student applications using csv"
  task :update_apps_file, [:newFlag, :file] => :environment do |t, args|

    flagged_count = 0
    accepted_count = 0

    emailList = File.read(args[:file]).split(",").map(&:strip)

    emailList.each do |email|
      list_of_apps = EventApplication.joins(:user).where("users.email = '#{email}'")
      list_of_apps.each do |app|
        app.status = args[:newFlag]
        app.save(:validate => false)
        accepted_count += 1
        UserMailer.accepted_email(app.user).deliver_now
    
      end #End of event application check
    end

    puts "Flagged Applications: #{flagged_count}"
    puts "Accepted Applications: #{accepted_count}"
    puts "Total Applications Considered: #{flagged_count+accepted_count}"
  end

end
