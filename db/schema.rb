# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140409230520) do

  create_table "companies", force: true do |t|
    t.string   "name"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "phone_number"
    t.decimal  "average_rating",    default: 0.0
    t.integer  "total_ratings",     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "companies", ["name"], name: "index_companies_on_name", unique: true

  create_table "documents", force: true do |t|
    t.integer  "driver_id"
    t.string   "doc_file_name"
    t.string   "doc_content_type"
    t.integer  "doc_file_size"
    t.datetime "doc_updated_at"
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "drivers", force: true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.date     "date_of_birth"
    t.string   "type_id"
    t.string   "address"
    t.string   "city",                     default: "Nashville"
    t.string   "state",                    default: "TN"
    t.integer  "zipcode"
    t.string   "race"
    t.string   "sex"
    t.integer  "height"
    t.integer  "weight"
    t.string   "license"
    t.string   "phone_number"
    t.date     "training_completion_date"
    t.date     "permit_expiration_date"
    t.integer  "permit_number"
    t.string   "status"
    t.string   "vehicle_owner"
    t.integer  "vehicle_number"
    t.integer  "company_id"
    t.date     "physical_expiration_date"
    t.boolean  "valid",                    default: true
    t.string   "beacon_id"
    t.decimal  "average_rating",           default: 0.0
    t.integer  "total_ratings",            default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", force: true do |t|
    t.integer  "driver_id"
    t.string   "rider_id"
    t.integer  "ride_id"
    t.integer  "rating"
    t.string   "comments"
    t.datetime "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "riders", force: true do |t|
    t.string   "uuid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "riders", ["uuid"], name: "index_riders_on_uuid", unique: true

  create_table "rides", force: true do |t|
    t.integer  "driver_id"
    t.string   "rider_id"
    t.integer  "rating_id"
    t.float    "start_latitude",  limit: 53
    t.float    "start_longitude", limit: 53
    t.float    "end_latitude",    limit: 53
    t.float    "end_longitude",   limit: 53
    t.decimal  "estimated_fare"
    t.decimal  "actual_fare"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name",             default: "",    null: false
    t.string   "last_name",              default: "",    null: false
    t.string   "username",               default: "",    null: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "admin",                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
