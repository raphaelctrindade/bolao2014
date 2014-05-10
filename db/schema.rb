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

ActiveRecord::Schema.define(version: 20140510190055) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bets", force: true do |t|
    t.integer  "user_id",                null: false
    t.integer  "points",     default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bets", ["user_id"], name: "index_bets_on_user_id", unique: true, using: :btree

  create_table "teams", force: true do |t|
    t.string   "name_en",              null: false
    t.string   "name_pt",              null: false
    t.string   "acronym",    limit: 3, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["acronym"], name: "index_teams_on_acronym", unique: true, using: :btree
  add_index "teams", ["name_en"], name: "index_teams_on_name_en", unique: true, using: :btree
  add_index "teams", ["name_pt"], name: "index_teams_on_name_pt", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email",                           null: false
    t.string   "time_zone",                       null: false
    t.string   "locale",                          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token",               null: false
    t.string   "authentication_token"
    t.datetime "authentication_token_expires_at"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", unique: true, using: :btree

end
