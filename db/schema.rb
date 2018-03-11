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

ActiveRecord::Schema.define(version: 20180309011739) do

  create_table "cards", force: :cascade do |t|
    t.integer "company_id"
    t.integer "user"
    t.integer "country", default: 779
    t.integer "credit1"
    t.integer "credit2"
    t.integer "status", default: 0
    t.boolean "credit2_enabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "client"
    t.integer "pin"
    t.index ["company_id"], name: "index_cards_on_company_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.integer "admin"
    t.integer "clientcount"
    t.string "employers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
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
    t.string "username", default: "", null: false
    t.string "name"
    t.string "last_name"
    t.date "birth_date"
    t.text "bio"
    t.integer "dni"
    t.string "uid"
    t.string "provider"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.integer "permissions", default: 1
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
