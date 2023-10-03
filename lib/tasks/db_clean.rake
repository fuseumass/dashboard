namespace :application do
    desc 'Clean Database'
    task :db_clean => :environment do

        # Delete all users
        puts "Deleting all users..."
        User.delete_all

        # Delete all event applications
        puts "Deleting all event applications..."
        EventApplication.delete_all

        # Delete all prizes
        puts "Deleting all prizes..."
        Prize.delete_all

        # Delete all projects
        puts "Deleting all projects..."
        Project.delete_all

    end
end