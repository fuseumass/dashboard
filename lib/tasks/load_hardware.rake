require 'csv'
namespace :hardware do 
  desc 'Create all the hardware items'
  task :create, [:var] => :environment do |task, args|
    
    # To pass the right argument for the rake command, refer to the sample command:
    # sudo ./docker_shell rake hardware:create[lib/tasks/sample_hardware_data.csv]
    # You may chose to edit the sample CSV or pass in a different location of your CSV file within the brackets

  hardware_items = []
  if args.var.nil?
    puts("No Arguments Received")
  else
    csvPath = args.var
    header = true
  
    CSV.foreach(csvPath) do |row|
      if header == true
          header = false
      else
          item = HardwareItem.new(
              {
              uid: row[0],
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

end