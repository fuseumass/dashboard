# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_10_11_233048) do

  create_table "emails", force: :cascade do |t|
    t.string "subject"
    t.string "message"
    t.string "mailing_list"
    t.string "status"
    t.string "sent_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "location"
    t.string "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "host"
  end

  create_table "feature_flags", force: :cascade do |t|
    t.string "name"
    t.boolean "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hardware_checkouts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "hardware_item_id"
    t.index ["hardware_item_id"], name: "index_hardware_checkouts_on_hardware_item_id"
    t.index ["user_id"], name: "index_hardware_checkouts_on_user_id"
  end

  create_table "hardware_items", force: :cascade do |t|
    t.integer "upc"
    t.string "name"
    t.string "link"
    t.string "category"
    t.integer "count"
    t.boolean "available"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "majors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mentorship_requests", force: :cascade do |t|
    t.integer "user_id"
    t.integer "mentor_id"
    t.string "title"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "urgency"
    t.string "description"
    t.string "tech", default: "{}"
    t.string "screenshot_file_name"
    t.string "screenshot_content_type"
    t.integer "screenshot_file_size"
    t.datetime "screenshot_updated_at"
  end

  create_table "prizes", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "criteria"
    t.string "sponsor"
    t.integer "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "link"
    t.string "team_members"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "projectimage_file_name"
    t.string "projectimage_content_type"
    t.integer "projectimage_file_size"
    t.datetime "projectimage_updated_at"
    t.string "inspiration"
    t.string "does_what"
    t.string "built_how"
    t.string "challenges"
    t.string "accomplishments"
    t.string "learned"
    t.string "next"
    t.string "built_with"
    t.string "prizes", default: "{}"
    t.boolean "power"
    t.integer "table_id"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "universities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_type", default: "attendee"
    t.boolean "rsvp", default: false
    t.boolean "check_in", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
