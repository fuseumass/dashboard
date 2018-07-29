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

ActiveRecord::Schema.define(version: 2018_07_29_035032) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

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
    t.integer "user_id"
    t.string "application_status", default: "undecided"
    t.string "name"
    t.string "phone"
    t.string "age"
    t.string "sex"
    t.string "university"
    t.string "major"
    t.string "grad_year"
    t.boolean "food_restrictions"
    t.text "food_restrictions_info"
    t.string "t_shirt"
    t.string "linkedin"
    t.string "github"
    t.boolean "previous_hackathon_attendance"
    t.boolean "transportation"
    t.string "transportation_location"
    t.string "programming_skills_list", default: "{}"
    t.text "how_did_you_hear_about_hackumass"
    t.text "future_hardware_for_hackumass"
    t.boolean "waiver_liability_agreement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "accepted_applicants", default: 0
    t.integer "rejected_applicants", default: 0
    t.integer "waitlisted_applicants", default: 0
    t.string "hardware_skills_list", default: "{}"
    t.boolean "flag", default: false
    t.binary "resume"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "location"
    t.string "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "time"
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
    t.string "help_type"
    t.integer "urgency"
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
