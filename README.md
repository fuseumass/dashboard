## Database Schema
* We have a SQL database consisting of the following columns
```sql
create_table "event_applications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "status", default: "undecided"
    t.boolean "flag", default: false
    t.string "name"
    t.string "phone"
    t.string "age"
    t.string "sex"
    t.string "university"
    t.string "major"
    t.string "grad_year"
    t.boolean "food_restrictions"
    t.text "food_restrictions_info"
    t.string "resume_file_name"
    t.string "resume_content_type"
    t.integer "resume_file_size"
    t.datetime "resume_updated_at"
    t.string "t_shirt_size"
    t.string "linkedin_url"
    t.string "github_url"
    t.boolean "prev_attendance"
    t.string "programming_skills", default: "{}"
    t.string "hardware_skills", default: "{}"
    t.text "referral_info"
    t.text "future_hardware_suggestion"
    t.boolean "waiver_liability_agreement"
    t.string "education_lvl"
  end
```
---
## What is the Event Application
* All about Applications, Applicants.
* Create, delete, update applications/applicants

---


## What URL can be given to participants to apply
* <%= render 'shared/home_pages/new_user_view'%>
* devise/registration/new
* get 'apply' => 'event_applications#new'

---
## What questions are the questions that our application has?
* Name, Phone, Age, Sex
* University, major, graduation year
* Food restrictions
* Resume
* Linkedin, Github URLs
* Programming and Hardware skills


---
## What files manage event applications (Model, View, & Controller)

### app/models/event_application
* Validates all the field inputs by the applicant
* Validates for Resume using active storage gem

### event_applications_controller
* Has methods which create, show, update and destroy applications

### app/views/event_applications
* index.html.erb - Applications
* _form.html.erb - Sign Up Form - for new Applicants


---
## How to add/remove questions in the event application
* Controller, with a create method ?
* app/views/_form.html.erb - Change it from the backend

---
## What special styling and or javascript is there in Event Applications
* event_application.scss
* event_application.js

---
## How do we verify resumes
* Models/event_application
* Checks if there is an attached file 
* Checks the content type is PDF and size is less than 2MB
* Uses Paperclip/active_storage to parse the Resume
* Checks if the resume has major, university, length>=400
* Renames the resume to {id}_{first_name}_{last_name}


---
## Link to the Amazon S3 Documentation that will explain how to set up the bucket
