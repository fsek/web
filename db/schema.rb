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

ActiveRecord::Schema.define(version: 20410822171450) do

  create_table "album_categories", force: true do |t|
    t.string   "name"
    t.text     "text"
    t.boolean  "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "album_categories_albums", id: false, force: true do |t|
    t.integer "album_id"
    t.integer "album_category_id"
  end

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

  create_table "candidates", force: true do |t|
    t.integer  "post_id"
    t.integer  "profile_id"
    t.integer  "election_id"
    t.text     "motivation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stil_id"
    t.string   "email"
    t.string   "phone"
    t.string   "name"
    t.string   "lastname"
  end

  add_index "candidates", ["post_id"], name: "index_candidates_on_post_id"
  add_index "candidates", ["profile_id"], name: "index_candidates_on_profile_id"

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
    t.string   "title"
    t.string   "url"
    t.text     "description"
    t.integer  "president"
    t.integer  "vicepresident"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.boolean  "public",            default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contact_id"
  end

  create_table "document_group_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "document_groups", force: true do |t|
    t.string   "name"
    t.date     "production_date"
    t.integer  "document_group_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", force: true do |t|
    t.string   "pdf_file_name"
    t.string   "pdf_content_type"
    t.integer  "pdf_file_size"
    t.datetime "pdf_updated_at"
    t.string   "title"
    t.boolean  "public"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "document_group_id"
    t.date     "production_date"
    t.date     "revision_date"
  end

  add_index "documents", ["document_group_id"], name: "index_documents_on_document_group_id"

  create_table "elections", force: true do |t|
    t.datetime "start"
    t.datetime "end"
    t.boolean  "visible"
    t.string   "url"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "candidate_mail"
    t.text     "nominate_mail"
    t.text     "text_before"
    t.text     "text_during"
    t.text     "text_after"
    t.text     "extra_text"
    t.text     "candidate_mail_star"
    t.string   "mail_link"
    t.string   "mail_styrelse_link"
  end

  create_table "elections_posts", id: false, force: true do |t|
    t.integer "election_id"
    t.integer "post_id"
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

  create_table "faqs", force: true do |t|
    t.string   "question"
    t.text     "answer"
    t.integer  "sorting_index"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
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

  create_table "menus", force: true do |t|
    t.string   "location"
    t.integer  "index"
    t.string   "link"
    t.string   "name"
    t.boolean  "visible"
    t.boolean  "turbolinks", default: true
    t.boolean  "blank_p"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.boolean  "front_page"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "profile_id"
  end

  create_table "nominations", force: true do |t|
    t.integer  "post_id"
    t.integer  "election_id"
    t.string   "name"
    t.string   "email"
    t.text     "motivation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone"
    t.string   "stil_id"
  end

  create_table "notices", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "public"
    t.date     "d_publish"
    t.date     "d_remove"
    t.integer  "sort"
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

  create_table "posts", force: true do |t|
    t.string   "title"
    t.integer  "limit",         default: 0
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "council_id"
    t.boolean  "extra_text"
    t.string   "elected_by"
    t.string   "elected_at"
    t.text     "election_text"
    t.boolean  "styrelse"
    t.integer  "recLimit",      default: 0
    t.boolean  "car_rent"
  end

  create_table "posts_profiles", id: false, force: true do |t|
    t.integer "post_id"
    t.integer "profile_id"
  end

  create_table "profiles", force: true do |t|
    t.string   "name"
    t.string   "lastname"
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
    t.string   "email"
    t.string   "stil_id"
    t.string   "phone"
  end

  create_table "rents", force: true do |t|
    t.datetime "d_from"
    t.datetime "d_til"
    t.string   "name"
    t.string   "lastname"
    t.string   "email"
    t.string   "phone"
    t.text     "purpose",     default: ""
    t.boolean  "disclaimer",  default: false
    t.string   "status",      default: "Ej bestämd"
    t.boolean  "aktiv",       default: true
    t.integer  "council_id"
    t.integer  "profile_id"
    t.text     "comment"
    t.boolean  "service",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "access_code"
  end

  add_index "rents", ["d_from"], name: "index_rents_on_d_from"
  add_index "rents", ["d_til"], name: "index_rents_on_d_til"

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

  create_table "taggings", force: true do |t|
    t.integer  "document_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["document_id"], name: "index_taggings_on_document_id"
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id"

  create_table "tags", force: true do |t|
    t.string   "name"
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

  create_table "work_posts", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "company"
    t.datetime "deadline"
    t.string   "for"
    t.boolean  "visible"
    t.datetime "publish"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "responsible"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
    t.string   "link"
    t.string   "kind"
    t.integer  "row_order"
  end

end
