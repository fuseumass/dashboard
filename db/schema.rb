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

ActiveRecord::Schema.define(version: 20170614025022) do

  create_table "event_applications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "application_status",               default: "undecided"
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "age"
    t.string   "sex"
    t.string   "university"
    t.string   "major"
    t.string   "grad_year"
    t.boolean  "food_restrictions"
    t.text     "food_restrictions_info"
    t.string   "t_shirt"
    t.binary   "resume_file"
    t.string   "resume_file_name"
    t.string   "linkedin"
    t.string   "github"
    t.boolean  "previous_hackathon_attendance"
    t.boolean  "transportation"
    t.string   "transportation_location"
    t.string   "programmer_type_list",             default: "{}"
    t.string   "programming_skills_list",          default: "{}"
    t.boolean  "interested_in_hardware_hacks",     default: false
    t.string   "interested_hardware_hacks_list",   default: "{}"
    t.text     "how_did_you_hear_about_hackumass"
    t.text     "future_hardware_for_hackumass"
    t.boolean  "waiver_liability_agreement"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.integer  "accepted_applicants",              default: 0
    t.integer  "rejected_applicants",              default: 0
    t.integer  "waitlisted_applicants",            default: 0
  end

  create_table "hardware_checkouts", force: :cascade do |t|
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "user_id"
    t.integer  "hardware_item_id"
    t.index ["hardware_item_id"], name: "index_hardware_checkouts_on_hardware_item_id"
    t.index ["user_id"], name: "index_hardware_checkouts_on_user_id"
  end

  create_table "hardware_items", force: :cascade do |t|
    t.integer  "upc"
    t.string   "name"
    t.string   "link"
    t.string   "category"
    t.integer  "count"
    t.boolean  "available"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mentorship_requests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "mentor_id"
    t.string   "title"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "help_type"
    t.integer  "urgency"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",                                  null: false
    t.string   "last_name",                                   null: false
    t.string   "email",                  default: "",         null: false
    t.string   "encrypted_password",     default: "",         null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,          null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "user_type",              default: "attendee"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
