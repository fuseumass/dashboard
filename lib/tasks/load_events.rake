require 'csv'
namespace :event do 
  desc 'Import all the Events from CSV'
  task :create, [:var] => :environment do |task, args|
    
    # To pass the right argument for the rake command, refer to the sample command:
    # sudo ./docker_shell rake event:create[lib/tasks/sample_events_data.csv]
    # You may chose to edit the sample CSV or pass in a different location of your CSV file within the brackets

  events = []
  if args.var.nil?
    puts("No Arguments Received")
  else
    csvPath = args.var
    header = true
  
    CSV.foreach(csvPath) do |row|
      if header == true
          header = false
      else
          newEvent = Event.new(
              {
              title: row[0],
              description: row[1],
              location: row[2],
              host: row[3],
              start_time: row[4],
              end_time:row[5], 
              rsvpable:row[6],
              max_seats:row[7]
              })
          events.push(newEvent)
          
      end
    end

    events.each do |item|
      item.save
    end
  
  end
  
  end

end