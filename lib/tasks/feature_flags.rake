namespace :feature_flags do
  desc "Accept or flag student applications"
  task load_flags: :environment do

    feature_flag_names = ['event_applications', 'mentorship_requests', 'hardware', 'projects', 'project_submissions', 'check_in','prizes', 'events']
    display_names = { "event_applications" => "Applications", "mentorship_requests" => "Mentorship Requests", "hardware" => "Hardware Requests", "projects" => "Projects: View", "project_submissions" => "Projects: Create", "check_in" => "Check-Ins", "prizes" => "Prizes", "events" => "Schedule"}

    feature_flag_names.each do |flag_name|
      unless FeatureFlag.where(name: flag_name).exists?
        FeatureFlag.create(name: flag_name, value: false, display_name: display_names[flag_name])
        puts "Creating #{flag_name} feature flag."
      end
    end

    feature_flag_names.each do |flag_name|
      FeatureFlag.where(name: flag_name).update_all(display_name: display_names[flag_name])
      puts "Updating #{flag_name} feature flag."
    end

    puts 'All Feature flags created successfully!'

  end

end
