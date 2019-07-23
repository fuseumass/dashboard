## Database Schema
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

---
## What URL can be given to participants to apply

---
## What questions are the questions that our application has?

---
## What files manage event applications (Model, View, & Controller)

---
## How to add/remove questions in the event application

---
## What special styling and or javascript is there in Event Applications

---
## How do we verify resumes

---
## Link to the Amazon S3 Documentation that will explain how to set up the bucket
