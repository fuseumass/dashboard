puts '################# Rake Seed File Started #####################'
# puts 'Deleting all user...'
# User.delete_all
# puts 'All users deleted!'

puts ' '

5.times do |i|
    puts "Creating prizes #{i}"

    Prize.create(
        award: "Prize#{i}",
        description: "Amazing prize!",
        title: "Best Hack #{i}",
        sponsor: "Dashboard",
        priority: 1,
        project_selectable: i%2==0 ? true : false
    )
end

5.times do |i|
    puts "Creating user #{i}"

    u = User.where(email: "user#{i}@email.com")
    if u.exists?
        u = u[0]
    else
        u = User.create(
            first_name: "User#{i}", 
            last_name: "User#{i}", 
            email: "user#{i}@email.com", 
            password: "testpass", 
            password_confirmation: "testpass",
            user_type: "attendee"
        )
        u.save
    end

    if i % 6 == 5
        u.user_type = "mentor"
        u.save

        next
    end

    app = EventApplication.new(
        created_at: Time.now,
        updated_at: Time.now,
        user_id: u.id,
        name: "User#{i} User#{i}",
        phone: "+12345678901",
        age: 15,
        university: "Bovine University",
        major: "Rave Management",
        custom_fields: {}
    )

    is_checked_in = false

    if i % 6 == 0
        app.status = 'denied'
    elsif i % 6 == 1
        app.status = 'undecided'
    else
        app.status = 'accepted'
        u.rsvp = true
        u.check_in = true
        u.save
        is_checked_in = true
    end

    app.save(validate: false)

    if is_checked_in
        if i % 2 == 0
            proj = Project.new(
                created_at: Time.now,
                updated_at: Time.now,
                title: "Project#{i}",
                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "*3,
                link: "https://example.com",
                inspiration: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "*3,
                does_what: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "*3,
                built_how: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "*3,
                challenges: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "*3,
                accomplishments: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "*3,
                learned: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "*3,
                next: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "*3,
                built_with: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "*3,
                tech: ["HTML/CSS", "Javascript"],
                prizes: ["Best Hack #{i%10}", "Best Hack #{10+(i%10)}"],
                prizes_won: []
            )

            proj.save(validate: false)
            u.project_id = proj.id
            u.save
        else
            u.project_id = Project.last.id
            u.save
        end
    end
end


puts 'Creating admin user...'
User.create(first_name: "admin", last_name: "user", email: "admin@email.com", password: "testpass", password_confirmation: "testpass", user_type: "admin")
puts 'Admin user created successfuly!'

puts "Your database is full with fake data! You're all set! 🎉🎉🎉🎉🎉🎉🎉🎉🎉"
puts ' '
puts 'Admin credentials:'
puts 'Email: admin@email.com'
puts 'Password: testpass'

