namespace :feature_flags do
  desc "Accept or flag student applications"
  task load_flags: :environment do

    feature_flag_names = ['event_applications', 'application_mode', 'mentorship_requests', 'hardware', 'projects', 'project_submissions', 'check_in','prizes', 'events', 'judging']
    display_names = { "event_applications" => "Applications", "application_mode" => "Event Application Mode", "mentorship_requests" => "Mentorship Requests", "hardware" => "Hardware Requests", "projects" => "Projects: View", "project_submissions" => "Projects: Create", "check_in" => "Check-Ins", "prizes" => "Prizes", "events" => "Schedule", "judging" => "Judging"}
    description = { "event_applications" => "Enables hackers to start registering and applying to the hackathon", 
      "application_mode" => "closed",
      "mentorship_requests" => "Allows hackers to request mentor help", 
      "hardware" => "Enables the ability for hackers to checkout hardware", 
      "projects" => "Allows projects to be seen to the public", 
      "project_submissions" => "Gives Hackers the ability to submit projects as a team", 
      "check_in" => "Starts the hackathon by allowing volunteers the ability to check in hackers", 
      "prizes" => "Allows Prizes to be created and displayed for all hackers to see", 
      "events" => "Allows planning of events and shows the schedule to hackers",
      "judging" => "Allows for scoring of projects on Dashboard."}

    feature_flag_names.each do |flag_name|
      unless FeatureFlag.where(name: flag_name).exists?
        FeatureFlag.create(name: flag_name, value: false, display_name: display_names[flag_name], description: description[flag_name])
        puts "Creating #{flag_name} feature flag."
      end
    end

    feature_flag_names.each do |flag_name|
      FeatureFlag.where(name: flag_name).update_all(display_name: display_names[flag_name], description: description[flag_name])
      puts "Updating #{flag_name} feature flag."
    end

    puts 'All Feature Flags Created Successfully!'

  end

end
