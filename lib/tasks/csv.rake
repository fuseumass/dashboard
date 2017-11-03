namespace :csv do
    desc ""
    task rsvp: :environment do
      require 'csv'
      CSV.open("rsvp.csv", "w") do |csv|
        @all_applications = EventApplication.select(:name, :email, :university).where({rsvp: true})
        csv << ['Applicant Name', 'Email', 'Univeristy']
        @all_applications.each do |applicant|
        csv << [applicant.name, applicant.email, applicant.university]
        end
      end
    end
  
  end
  