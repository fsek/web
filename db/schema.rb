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

ActiveRecord::Schema.define(version: 20150331104940) do

  create_table "album_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "text",       limit: 65535
    t.boolean  "visible",    limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "album_categories_albums", id: false, force: :cascade do |t|
    t.integer "album_id",          limit: 4
    t.integer "album_category_id", limit: 4
  end

  create_table "albums", force: :cascade do |t|
    t.string   "title",             limit: 255
    t.text     "description",       limit: 65535
    t.string   "author",            limit: 255
    t.string   "location",          limit: 255
    t.boolean  "public",            limit: 1
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category",          limit: 255
    t.integer  "photo_category_id", limit: 4
  end

  create_table "albums_images", id: false, force: :cascade do |t|
    t.integer "album_id", limit: 4
    t.integer "image_id", limit: 4
  end

  create_table "albums_subcategories", id: false, force: :cascade do |t|
    t.integer "album_id",       limit: 4
    t.integer "subcategory_id", limit: 4
  end

  create_table "cafe_work_councils", force: :cascade do |t|
    t.integer  "cafe_work_id", limit: 4
    t.integer  "council_id",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "cafe_works", force: :cascade do |t|
    t.datetime "work_day"
    t.integer  "pass",         limit: 4
    t.integer  "lp",           limit: 4
    t.integer  "lv",           limit: 4
    t.integer  "profile_id",   limit: 4
    t.string   "name",         limit: 255
    t.string   "lastname",     limit: 255
    t.string   "phone",        limit: 255
    t.string   "email",        limit: 255
    t.boolean  "utskottskamp", limit: 1
    t.string   "access_code",  limit: 255
    t.integer  "d_year",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "candidates", force: :cascade do |t|
    t.integer  "post_id",     limit: 4
    t.integer  "profile_id",  limit: 4
    t.integer  "election_id", limit: 4
    t.text     "motivation",  limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stil_id",     limit: 255
    t.string   "email",       limit: 255
    t.string   "phone",       limit: 255
    t.string   "name",        limit: 255
    t.string   "lastname",    limit: 255
  end

  add_index "candidates", ["post_id"], name: "index_candidates_on_post_id", using: :btree
  add_index "candidates", ["profile_id"], name: "index_candidates_on_profile_id", using: :btree

  create_table "constants", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "value",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.boolean  "public",     limit: 1
    t.text     "text",       limit: 65535
    t.integer  "council_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "councils", force: :cascade do |t|
    t.string   "title",             limit: 255
    t.string   "url",               limit: 255
    t.text     "description",       limit: 65535
    t.string   "logo_file_name",    limit: 255
    t.string   "logo_content_type", limit: 255
    t.integer  "logo_file_size",    limit: 4
    t.datetime "logo_updated_at"
    t.boolean  "public",            limit: 1,     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contact_id",        limit: 4
    t.integer  "president_id",      limit: 4
    t.integer  "vicepresident_id",  limit: 4
  end

  create_table "documents", force: :cascade do |t|
    t.string   "pdf_file_name",    limit: 255
    t.string   "pdf_content_type", limit: 255
    t.integer  "pdf_file_size",    limit: 4
    t.datetime "pdf_updated_at"
    t.string   "title",            limit: 255
    t.boolean  "public",           limit: 1
    t.boolean  "download",         limit: 1
    t.string   "category",         limit: 255
    t.integer  "profile_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "elections", force: :cascade do |t|
    t.datetime "start"
    t.datetime "end"
    t.boolean  "visible",             limit: 1
    t.string   "url",                 limit: 255
    t.string   "title",               limit: 255
    t.text     "description",         limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "candidate_mail",      limit: 65535
    t.text     "nominate_mail",       limit: 65535
    t.text     "text_before",         limit: 65535
    t.text     "text_during",         limit: 65535
    t.text     "text_after",          limit: 65535
    t.text     "extra_text",          limit: 65535
    t.text     "candidate_mail_star", limit: 65535
    t.string   "mail_link",           limit: 255
    t.string   "mail_styrelse_link",  limit: 255
  end

  create_table "elections_posts", id: false, force: :cascade do |t|
    t.integer "election_id", limit: 4
    t.integer "post_id",     limit: 4
  end

  create_table "events", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.string   "author",             limit: 255
    t.text     "description",        limit: 65535
    t.string   "location",           limit: 255
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean  "all_day",            limit: 1
    t.string   "category",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
  end

  create_table "faqs", force: :cascade do |t|
    t.string   "question",      limit: 255
    t.text     "answer",        limit: 65535
    t.integer  "sorting_index", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category",      limit: 255
  end

  add_index "faqs", ["category"], name: "index_faqs_on_category", using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "description",       limit: 255
    t.integer  "album_id",          limit: 4
    t.string   "foto_file_name",    limit: 255
    t.string   "foto_content_type", limit: 255
    t.integer  "foto_file_size",    limit: 4
    t.datetime "foto_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "captured"
    t.integer  "subcategory_id",    limit: 4
  end

  create_table "menus", force: :cascade do |t|
    t.string   "location",   limit: 255
    t.integer  "index",      limit: 4
    t.string   "link",       limit: 255
    t.string   "name",       limit: 255
    t.boolean  "visible",    limit: 1
    t.boolean  "turbolinks", limit: 1,   default: true
    t.boolean  "blank_p",    limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.text     "content",            limit: 65535
    t.boolean  "front_page",         limit: 1
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "profile_id",         limit: 4
  end

  create_table "nominations", force: :cascade do |t|
    t.integer  "post_id",     limit: 4
    t.integer  "election_id", limit: 4
    t.string   "name",        limit: 255
    t.string   "email",       limit: 255
    t.text     "motivation",  limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone",       limit: 255
    t.string   "stil_id",     limit: 255
  end

  create_table "notices", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.text     "description",        limit: 65535
    t.boolean  "public",             limit: 1
    t.date     "d_publish"
    t.date     "d_remove"
    t.integer  "sort",               limit: 4
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_elements", force: :cascade do |t|
    t.integer  "displayIndex",         limit: 4
    t.boolean  "sidebar",              limit: 1
    t.boolean  "visible",              limit: 1
    t.text     "text",                 limit: 65535
    t.string   "headline",             limit: 255
    t.boolean  "border",               limit: 1
    t.string   "name",                 limit: 255
    t.boolean  "pictureR",             limit: 1
    t.string   "picture_file_name",    limit: 255
    t.string   "picture_content_type", limit: 255
    t.integer  "picture_file_size",    limit: 4
    t.datetime "picture_updated_at"
    t.integer  "page_id",              limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "council_id", limit: 4
    t.string   "url",        limit: 255
    t.boolean  "visible",    limit: 1
    t.string   "title",      limit: 255
  end

  add_index "pages", ["council_id"], name: "index_pages_on_council_id", using: :btree
  add_index "pages", ["url"], name: "index_pages_on_url", using: :btree

  create_table "permission_posts", force: :cascade do |t|
    t.integer  "permission_id", limit: 4
    t.integer  "post_id",       limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "subject_class", limit: 255
    t.string   "action",        limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "photo_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "text",       limit: 255
    t.boolean  "visible",    limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title",         limit: 255
    t.integer  "limit",         limit: 4,     default: 0
    t.text     "description",   limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "council_id",    limit: 4
    t.boolean  "extra_text",    limit: 1
    t.string   "elected_by",    limit: 255
    t.string   "elected_at",    limit: 255
    t.text     "election_text", limit: 65535
    t.boolean  "styrelse",      limit: 1
    t.integer  "recLimit",      limit: 4,     default: 0
    t.boolean  "car_rent",      limit: 1
  end

  create_table "posts_profiles", id: false, force: :cascade do |t|
    t.integer "post_id",    limit: 4
    t.integer "profile_id", limit: 4
  end

  create_table "profiles", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.string   "program",             limit: 255
    t.integer  "start_year",          limit: 4
    t.integer  "user_id",             limit: 4
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size",    limit: 4
    t.datetime "avatar_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "first_post",          limit: 4
    t.string   "email",               limit: 255
    t.string   "stil_id",             limit: 255
    t.string   "phone",               limit: 255
    t.string   "lastname",            limit: 255
  end

  create_table "rents", force: :cascade do |t|
    t.datetime "d_from"
    t.datetime "d_til"
    t.string   "name",        limit: 255
    t.string   "lastname",    limit: 255
    t.string   "email",       limit: 255
    t.string   "phone",       limit: 255
    t.text     "purpose",     limit: 65535
    t.boolean  "disclaimer",  limit: 1,     default: false
    t.boolean  "aktiv",       limit: 1,     default: true
    t.integer  "council_id",  limit: 4
    t.integer  "profile_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment",     limit: 65535
    t.string   "status",      limit: 255,   default: "Ej bestÃƒÂ¤md"
    t.boolean  "service",     limit: 1,     default: false
    t.string   "access_code", limit: 255
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",        limit: 255,   null: false
    t.string   "title",       limit: 255,   null: false
    t.text     "description", limit: 65535, null: false
    t.text     "the_role",    limit: 65535, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "short_links", force: :cascade do |t|
    t.string "link",   limit: 255,   null: false
    t.text   "target", limit: 65535, null: false
  end

  add_index "short_links", ["link"], name: "index_short_links_on_link", using: :btree

  create_table "subcategories", force: :cascade do |t|
    t.string   "text",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",               limit: 255,              null: false
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "role_id",                limit: 4,   default: 2,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "work_posts", force: :cascade do |t|
    t.string   "title",                limit: 255
    t.text     "description",          limit: 65535
    t.string   "company",              limit: 255
    t.datetime "deadline"
    t.string   "for",                  limit: 255
    t.boolean  "visible",              limit: 1
    t.datetime "publish"
    t.string   "picture_file_name",    limit: 255
    t.string   "picture_content_type", limit: 255
    t.integer  "picture_file_size",    limit: 4
    t.datetime "picture_updated_at"
    t.integer  "responsible",          limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category",             limit: 255
    t.string   "link",                 limit: 255
    t.string   "kind",                 limit: 255
    t.integer  "row_order",            limit: 4
  end

end
