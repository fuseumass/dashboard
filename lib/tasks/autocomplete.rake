require 'csv'

namespace :application do
  desc 'Import CSV Data from Majors & Universities to Import'
  task :autocomplete => :environment do

    # Import data for
    Major.delete_all
    csv_file_path = 'db/application_autocomplete/majors-list.csv'
    CSV.foreach(csv_file_path, encoding: 'iso-8859-1:utf-8') do |row|
        Major.create!({
          :name => row[1]     
        })
        puts row[1] + " added!"
    end

    # Import data for university dropdown
    University.delete_all
    csv_file_path = 'db/application_autocomplete/colleges.csv'
    CSV.foreach(csv_file_path, encoding: 'iso-8859-1:utf-8') do |row|
      University.create!({
                             :name => row[1]
                         })
      puts row[1] + " added!"
    end

  end
end
