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

ActiveRecord::Schema.define(version: 20410822171370) do

  create_table "albums", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "author"
    t.string   "location"
    t.boolean  "public"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
    t.integer  "photo_category_id"
  end

  create_table "albums_images", id: false, force: true do |t|
    t.integer "album_id"
    t.integer "image_id"
  end

  create_table "albums_subcategories", id: false, force: true do |t|
    t.integer "album_id"
    t.integer "subcategory_id"
  end

  create_table "contacts", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.boolean  "public"
    t.text     "text"
    t.integer  "council_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "councils", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "url"
    t.text     "description"
    t.integer  "president"
    t.integer  "vicepresident"
    t.boolean  "public"
    t.integer  "contact_id"
  end

  create_table "events", force: true do |t|
    t.string   "title"
    t.string   "author"
    t.text     "description"
    t.string   "location"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean  "all_day"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "images", force: true do |t|
    t.string   "description"
    t.integer  "album_id"
    t.string   "foto_file_name"
    t.string   "foto_content_type"
    t.integer  "foto_file_size"
    t.datetime "foto_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "captured"
    t.integer  "subcategory_id"
  end

  create_table "lists", force: true do |t|
    t.string   "category"
    t.string   "name"
    t.string   "string1"
    t.integer  "int1"
    t.boolean  "bool1"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "author"
    t.boolean  "front_page"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_elements", force: true do |t|
    t.integer  "displayIndex"
    t.boolean  "sidebar"
    t.boolean  "visible"
    t.text     "text"
    t.string   "headline"
    t.boolean  "border"
    t.string   "name"
    t.boolean  "pictureR"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "council_id"
  end

  create_table "photo_categories", force: true do |t|
    t.string   "name"
    t.string   "text"
    t.boolean  "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phrasing_phrase_versions", force: true do |t|
    t.integer  "phrasing_phrase_id"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phrasing_phrases", force: true do |t|
    t.string   "locale"
    t.string   "key"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "posts" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "posts_profiles", id: false, force: true do |t|
    t.integer "post_id"
    t.integer "profile_id"
  end

  create_table "profiles", force: true do |t|
    t.string   "name"
    t.string   "program"
    t.integer  "start_year"
    t.integer  "user_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "first_post"
  end

  create_table "roles", force: true do |t|
    t.string   "name",        null: false
    t.string   "title",       null: false
    t.text     "description", null: false
    t.text     "the_role",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subcategories", force: true do |t|
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username",                            null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "role_id",                default: 2,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
