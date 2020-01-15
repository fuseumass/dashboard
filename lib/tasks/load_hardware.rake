namespace :hardware do
  desc 'Create all the hardware items'
  task :create => :environment do


    hardware_items.each do |item|
      item.save
    end


    

  end
end