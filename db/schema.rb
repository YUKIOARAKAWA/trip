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

ActiveRecord::Schema.define(version: 20160829090928) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "areas", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "blogs", force: :cascade do |t|
    t.string   "Test"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pins", force: :cascade do |t|
    t.integer  "place_id"
    t.integer  "user_id"
    t.string   "comment"
    t.integer  "want"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "pins", ["place_id"], name: "index_pins_on_place_id", using: :btree
  add_index "pins", ["user_id"], name: "index_pins_on_user_id", using: :btree

  create_table "places", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "plan_id"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "route"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "from"
    t.datetime "to"
  end

  add_index "places", ["plan_id"], name: "index_places_on_plan_id", using: :btree
  add_index "places", ["user_id"], name: "index_places_on_user_id", using: :btree

  create_table "plan_users", force: :cascade do |t|
    t.integer  "plan_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "plan_users", ["plan_id"], name: "index_plan_users_on_plan_id", using: :btree
  add_index "plan_users", ["user_id"], name: "index_plan_users_on_user_id", using: :btree

  create_table "plans", force: :cascade do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "area_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "plans", ["area_id"], name: "index_plans_on_area_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "uid"
    t.string   "provider"
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "pins", "places"
  add_foreign_key "pins", "users"
  add_foreign_key "places", "plans"
  add_foreign_key "places", "users"
  add_foreign_key "plan_users", "plans"
  add_foreign_key "plan_users", "users"
  add_foreign_key "plans", "areas"
end
