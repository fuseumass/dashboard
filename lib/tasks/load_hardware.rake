require 'csv'
namespace :hardware do
  desc 'Create all the hardware items'
  task :create => :environment do

  hardware_items = []
  csvPath = "lib/tasks/sample_hardware_data.csv"
  header = true
  hardware_items = []

CSV.foreach(csvPath) do |row|
    if header == true
        header = false
    else
        item = HardwareItem.new(
            {
            upc: row[0],
            name: row[1],
            count: row[2],
            category: row[3],
            location: row[4]
            })
        hardware_items.push(item)
        
      end
  end

    hardware_items.each do |item|
      item.save
    end

  end
end