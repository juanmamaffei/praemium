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

ActiveRecord::Schema.define(version: 20180812015655) do

  create_table "cards", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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
    t.string "number"
    t.index ["company_id"], name: "index_cards_on_company_id"
    t.index ["number"], name: "index_cards_on_number", unique: true
  end

  create_table "companies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "url"
    t.integer "admin"
    t.integer "clientcount"
    t.string "employers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "alias"
    t.string "cover_file_name"
    t.string "cover_content_type"
    t.integer "cover_file_size"
    t.datetime "cover_updated_at"
    t.text "markdown_content"
    t.text "content"
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at"
    t.string "picture_file_name"
    t.string "picture_content_type"
    t.integer "picture_file_size"
    t.datetime "picture_updated_at"
    t.string "facebook"
    t.string "twitter"
    t.string "website"
    t.string "email"
    t.string "instagram"
    t.string "linkedin"
    t.string "phone"
    t.string "whatsapp"
    t.text "about_us"
    t.boolean "about_us_enabled"
    t.text "other_info"
    t.boolean "other_info_enabled"
    t.integer "template"
    t.boolean "store_enabled"
  end

  create_table "transactions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "card_id"
    t.integer "company_id"
    t.integer "user_id"
    t.integer "amount"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_transactions_on_card_id"
    t.index ["company_id"], name: "index_transactions_on_company_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
