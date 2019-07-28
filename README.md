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
* localhost:3000/apply.html

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

### Model - app/models/event_application
* Validates all the field inputs by the applicant
* Validates for Resume using active storage gem

### View - app/views/event_applications
* index.html.erb - Applications
* _form.html.erb - Sign Up Form - for new Applicants

### Controller - event_applications_controller
* Has methods which create, show, update and destroy applications

---
## What special styling and or javascript is there in Event Applications
### CSS - event_application.scss
* Different Nav button containers - Background color is global instead of a local one
* Other styling includes status margin, resume container, error text

### Javascript - 
* Reload function is to make all the hidden field persist through refresh and reloads.
* Number auto format - Formats the phone number to something like ``(XXX) XXX-XXXX``
* charCounter - Count number of characters in the text box
* unhide, hide - toggles the view to unhide and hide from the viewer by changing CSS display
* toggleHiddenField - toggles hideField and unhideField with respect to the checkbox being unchecked or checked

---
## How do we verify resumes
* Models/event_application
* Checks if there is an attached file 
* Checks the content type is PDF and size is less than 2MB
* Uses Paperclip/active_storage to parse the Resume
* Checks if the resume has major, university, length>=400
* Renames the resume to {id}_{first_name}_{last_name}
