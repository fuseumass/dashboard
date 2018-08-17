namespace :feature_flags do
  desc "Accept or flag student applications"
  task load_flags: :environment do

    FeatureFlag.delete_all
    FeatureFlag.create(name: 'event_applications', value: false)
    FeatureFlag.create(name: 'mentorship_requests', value: false)
    FeatureFlag.create(name: 'hardware', value: false)

    puts 'Feature flags created successfully!'

  end

end
