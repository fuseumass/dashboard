require 'csv'

namespace :csvmajors do

  desc "Import CSV Data from Majors to Import"
  task :taskname => :environment do
    Major.delete_all
    csv_file_path = 'db/majors-list.csv'

    CSV.foreach(csv_file_path, encoding: 'iso-8859-1:utf-8') do |row|
        Major.create!({
          :name => row[1]     
        })
        puts row[1] + " added!"
      end
    end
  end

namespace :csvcolleges do

  desc "Import CSV Data from Colleges to Import"
  task :taskname => :environment do
    University.delete_all
    csv_file_path = 'db/colleges.csv'

    CSV.foreach(csv_file_path, encoding: 'iso-8859-1:utf-8') do |row|
        University.create!({
          :name => row[1]     
        })
        puts row[1] + " added!"
      end
    end
  end