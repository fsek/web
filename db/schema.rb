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

ActiveRecord::Schema.define(version: 20160220130722) do

  create_table "album_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "text",       limit: 65535
    t.boolean  "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "album_categories_albums", id: false, force: :cascade do |t|
    t.integer "album_id",          limit: 4
    t.integer "album_category_id", limit: 4
  end

  create_table "albums", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "description", limit: 65535
    t.string   "location",    limit: 255
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category",    limit: 255
  end

  create_table "albums_images", id: false, force: :cascade do |t|
    t.integer "album_id", limit: 4
    t.integer "image_id", limit: 4
  end

  create_table "albums_subcategories", id: false, force: :cascade do |t|
    t.integer "album_id",       limit: 4
    t.integer "subcategory_id", limit: 4
  end

  create_table "cafe_shifts", force: :cascade do |t|
    t.datetime "start",           null: false
    t.integer  "pass",  limit: 4, null: false
    t.integer  "lp",    limit: 4, null: false
    t.integer  "lv",    limit: 4, null: false
  end

  create_table "cafe_work_councils", force: :cascade do |t|
    t.integer  "cafe_work_id", limit: 4
    t.integer  "council_id",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "cafe_worker_councils", force: :cascade do |t|
    t.integer "cafe_worker_id", limit: 4
    t.integer "council_id",     limit: 4
  end

  add_index "cafe_worker_councils", ["cafe_worker_id"], name: "index_cafe_worker_councils_on_cafe_worker_id", using: :btree
  add_index "cafe_worker_councils", ["council_id"], name: "index_cafe_worker_councils_on_council_id", using: :btree

  create_table "cafe_workers", force: :cascade do |t|
    t.integer  "user_id",       limit: 4,                  null: false
    t.integer  "cafe_shift_id", limit: 4,                  null: false
    t.boolean  "competition",               default: true
    t.string   "group",         limit: 255
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "cafe_workers", ["cafe_shift_id"], name: "index_cafe_workers_on_cafe_shift_id", using: :btree
  add_index "cafe_workers", ["group"], name: "index_cafe_workers_on_group", using: :btree
  add_index "cafe_workers", ["user_id"], name: "index_cafe_workers_on_user_id", using: :btree

  create_table "cafe_works", force: :cascade do |t|
    t.datetime "work_day"
    t.integer  "pass",         limit: 4
    t.integer  "lp",           limit: 4
    t.integer  "lv",           limit: 4
    t.string   "name",         limit: 255
    t.string   "lastname",     limit: 255
    t.string   "phone",        limit: 255
    t.string   "email",        limit: 255
    t.boolean  "utskottskamp"
    t.string   "access_code",  limit: 255
    t.integer  "d_year",       limit: 4
    t.integer  "user_id",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "firstname",    limit: 255
  end

  create_table "candidates", force: :cascade do |t|
    t.integer  "post_id",     limit: 4
    t.integer  "election_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",     limit: 4
  end

  add_index "candidates", ["election_id"], name: "index_candidates_on_election_id", using: :btree
  add_index "candidates", ["post_id"], name: "index_candidates_on_post_id", using: :btree
  add_index "candidates", ["user_id"], name: "index_candidates_on_user_id", using: :btree

  create_table "constants", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "value",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.boolean  "public"
    t.text     "text",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",       limit: 255
    t.integer  "post_id",    limit: 4
  end

  add_index "contacts", ["post_id"], name: "index_contacts_on_post_id", using: :btree
  add_index "contacts", ["slug"], name: "index_contacts_on_slug", using: :btree

  create_table "councils", force: :cascade do |t|
    t.string   "title",             limit: 255
    t.string   "url",               limit: 255
    t.text     "description",       limit: 65535
    t.string   "logo_file_name",    limit: 255
    t.string   "logo_content_type", limit: 255
    t.integer  "logo_file_size",    limit: 4
    t.datetime "logo_updated_at"
    t.boolean  "public",                          default: true
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
    t.boolean  "public"
    t.boolean  "download"
    t.string   "category",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",          limit: 4
  end

  create_table "elections", force: :cascade do |t|
    t.datetime "start"
    t.datetime "stop"
    t.boolean  "visible"
    t.string   "url",                 limit: 255
    t.string   "title",               limit: 255
    t.text     "description",         limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "candidate_mail",      limit: 65535
    t.text     "nominate_mail",       limit: 65535
    t.text     "candidate_mail_star", limit: 65535
    t.string   "mail_link",           limit: 255
    t.string   "board_mail_link",     limit: 255
    t.datetime "closing"
    t.string   "semester",            limit: 255,   default: "spring"
  end

  add_index "elections", ["url"], name: "index_elections_on_url", using: :btree

  create_table "elections_posts", id: false, force: :cascade do |t|
    t.integer "election_id", limit: 4
    t.integer "post_id",     limit: 4
  end

  create_table "event_registrations", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "event_id",   limit: 4
    t.boolean  "reserve"
    t.datetime "removed_at"
    t.integer  "remover_id", limit: 4
    t.text     "comment",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.string   "author",             limit: 255
    t.text     "description",        limit: 65535
    t.string   "location",           limit: 255
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean  "all_day"
    t.string   "category",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.integer  "council_id",         limit: 4
    t.integer  "user_id",            limit: 4
    t.string   "short",              limit: 255
    t.boolean  "signup"
    t.datetime "last_reg"
    t.string   "dot",                limit: 255
    t.integer  "slots",              limit: 4
    t.boolean  "drink"
    t.boolean  "food"
    t.boolean  "cash"
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
    t.integer  "album_id",          limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file",              limit: 255
    t.string   "filename",          limit: 255
    t.integer  "photographer_id",   limit: 4
    t.string   "photographer_name", limit: 255
    t.integer  "width",             limit: 4
    t.integer  "height",            limit: 4
  end

  add_index "images", ["album_id"], name: "index_images_on_album_id", using: :btree
  add_index "images", ["file"], name: "index_images_on_file", using: :btree
  add_index "images", ["filename"], name: "index_images_on_filename", using: :btree
  add_index "images", ["photographer_id"], name: "index_images_on_photographer_id", using: :btree

  create_table "menus", force: :cascade do |t|
    t.string   "location",   limit: 255
    t.integer  "index",      limit: 4
    t.string   "link",       limit: 255
    t.string   "name",       limit: 255
    t.boolean  "visible"
    t.boolean  "turbolinks",             default: true
    t.boolean  "blank_p"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "content",    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",    limit: 4
    t.string   "url",        limit: 255
    t.string   "image",      limit: 255
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
    t.boolean  "public"
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
    t.integer  "index",         limit: 4,     default: 1
    t.boolean  "sidebar"
    t.boolean  "visible",                     default: true
    t.text     "text",          limit: 65535
    t.string   "headline",      limit: 255
    t.string   "name",          limit: 255
    t.integer  "page_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "element_type",  limit: 255,   default: "text", null: false
    t.integer  "page_image_id", limit: 4
    t.integer  "contact_id",    limit: 4
  end

  add_index "page_elements", ["page_id"], name: "index_page_elements_on_page_id", using: :btree

  create_table "page_images", force: :cascade do |t|
    t.integer  "page_id",    limit: 4
    t.string   "image",      limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "page_images", ["page_id"], name: "index_page_images_on_page_id", using: :btree

  create_table "pages", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "council_id", limit: 4
    t.string   "url",        limit: 255
    t.boolean  "visible"
    t.string   "title",      limit: 255
    t.boolean  "public",                 default: true, null: false
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
    t.boolean  "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "post_users", force: :cascade do |t|
    t.integer  "post_id",    limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.integer  "limit",       limit: 4,     default: 0
    t.text     "description", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "council_id",  limit: 4
    t.string   "elected_by",  limit: 255
    t.string   "semester",    limit: 255,   default: "both"
    t.boolean  "board"
    t.integer  "rec_limit",   limit: 4,     default: 0
    t.boolean  "car_rent"
  end

  create_table "rents", force: :cascade do |t|
    t.datetime "d_from"
    t.datetime "d_til"
    t.string   "lastname",   limit: 255
    t.string   "email",      limit: 255
    t.string   "phone",      limit: 255
    t.text     "purpose",    limit: 65535
    t.boolean  "aktiv",                    default: true
    t.integer  "council_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment",    limit: 65535
    t.string   "status",     limit: 255,   default: "unconfirmed"
    t.boolean  "service",                  default: false
    t.integer  "user_id",    limit: 4
    t.string   "firstname",  limit: 255
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
    t.string   "username",               limit: 255
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
    t.string   "firstname",              limit: 255
    t.string   "lastname",               limit: 255
    t.string   "phone",                  limit: 255
    t.string   "stil_id",                limit: 255
    t.integer  "first_post_id",          limit: 4
    t.string   "avatar_file_name",       limit: 255
    t.string   "avatar_content_type",    limit: 255
    t.integer  "avatar_file_size",       limit: 4
    t.datetime "avatar_updated_at"
    t.integer  "start_year",             limit: 4
    t.string   "program",                limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "member_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "work_posts", force: :cascade do |t|
    t.string   "title",        limit: 255
    t.text     "description",  limit: 65535
    t.string   "company",      limit: 255
    t.datetime "deadline"
    t.string   "target_group", limit: 255
    t.boolean  "visible",                    default: true
    t.datetime "publish"
    t.integer  "user_id",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link",         limit: 255
    t.string   "kind",         limit: 255
    t.string   "image",        limit: 255
    t.string   "field",        limit: 255
  end

  add_index "work_posts", ["field"], name: "index_work_posts_on_field", using: :btree
  add_index "work_posts", ["target_group"], name: "index_work_posts_on_target_group", using: :btree
  add_index "work_posts", ["user_id"], name: "index_work_posts_on_user_id", using: :btree

  add_foreign_key "page_images", "pages"
end
