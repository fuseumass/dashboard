namespace :feature_flags do
  desc "Accept or flag student applications"
  task load_flags: :environment do

    FeatureFlag.delete_all
    FeatureFlag.create(name: 'Applications', value: false)
    FeatureFlag.create(name: 'Mentorship Dashboard', value: false)
    FeatureFlag.create(name: 'Hardware', value: false)
    FeatureFlag.create(name: 'Check In', value: false)
    FeatureFlag.create(name: 'Events', value: false)

    puts 'Feature flags created successfully!'

  end

end
