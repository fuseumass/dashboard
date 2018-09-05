namespace :feature_flags do
  desc "Accept or flag student applications"
  task load_flags: :environment do

    feature_flag_names = ['event_applications', 'mentorship_requests', 'hardware', 'projects', 'check_in']

    feature_flag_names.each do |flag_name|
      unless FeatureFlag.where(name: flag_name).exists?
        FeatureFlag.create(name: flag_name, value: false)
        puts "Creating #{flag_name} feature flag."
      end
    end

    puts 'All Feature flags created successfully!'

  end

end
