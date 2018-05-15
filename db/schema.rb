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

ActiveRecord::Schema.define(version: 20180513125456) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accesses", force: :cascade do |t|
    t.integer  "door_id"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["door_id"], name: "index_accesses_on_door_id", using: :btree
    t.index ["post_id"], name: "index_accesses_on_post_id", using: :btree
  end

  create_table "achievement_users", force: :cascade do |t|
    t.integer  "achievement_id"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["achievement_id", "user_id"], name: "index_achievement_users_on_achievement_id_and_user_id", unique: true, using: :btree
    t.index ["achievement_id"], name: "index_achievement_users_on_achievement_id", using: :btree
    t.index ["user_id"], name: "index_achievement_users_on_user_id", using: :btree
  end

  create_table "achievements", force: :cascade do |t|
    t.string   "name",                   null: false
    t.integer  "points",     default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "adventure_groups", force: :cascade do |t|
    t.integer  "points",       default: 0, null: false
    t.integer  "adventure_id"
    t.integer  "group_id"
    t.datetime "deleted_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["adventure_id"], name: "index_adventure_groups_on_adventure_id", using: :btree
    t.index ["deleted_at"], name: "index_adventure_groups_on_deleted_at", using: :btree
    t.index ["group_id"], name: "index_adventure_groups_on_group_id", using: :btree
  end

  create_table "adventure_translations", force: :cascade do |t|
    t.integer  "adventure_id",             null: false
    t.string   "locale",       limit: 255, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "title",        limit: 255
    t.text     "content"
    t.index ["adventure_id"], name: "index_adventure_translations_on_adventure_id", using: :btree
    t.index ["locale"], name: "index_adventure_translations_on_locale", using: :btree
  end

  create_table "adventures", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.text     "content"
    t.integer  "max_points",                                  null: false
    t.integer  "introduction_id"
    t.boolean  "publish_results",             default: false, null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "deleted_at"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "video",           limit: 255
    t.index ["deleted_at"], name: "index_adventures_on_deleted_at", using: :btree
    t.index ["end_date"], name: "index_adventures_on_end_date", using: :btree
    t.index ["introduction_id"], name: "index_adventures_on_introduction_id", using: :btree
    t.index ["start_date"], name: "index_adventures_on_start_date", using: :btree
  end

  create_table "album_translations", force: :cascade do |t|
    t.integer  "album_id",                null: false
    t.string   "locale",      limit: 255, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "title",       limit: 255
    t.text     "description"
    t.index ["album_id"], name: "index_album_translations_on_album_id", using: :btree
    t.index ["locale"], name: "index_album_translations_on_locale", using: :btree
  end

  create_table "albums", force: :cascade do |t|
    t.string   "title",        limit: 255
    t.text     "description"
    t.string   "location",     limit: 255
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category",     limit: 255
    t.integer  "images_count",             default: 0, null: false
  end

  create_table "blog_post_translations", force: :cascade do |t|
    t.integer  "blog_post_id",             null: false
    t.string   "locale",       limit: 255, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "title",        limit: 255
    t.text     "preamble"
    t.text     "content"
    t.index ["blog_post_id"], name: "index_blog_post_translations_on_blog_post_id", using: :btree
    t.index ["locale"], name: "index_blog_post_translations_on_locale", using: :btree
  end

  create_table "blog_posts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title",       limit: 255
    t.text     "preamble"
    t.text     "content"
    t.datetime "deleted_at"
    t.string   "cover_image", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["deleted_at"], name: "index_blog_posts_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_blog_posts_on_user_id", using: :btree
  end

  create_table "cafe_shifts", force: :cascade do |t|
    t.datetime "start", null: false
    t.integer  "pass",  null: false
    t.integer  "lp",    null: false
    t.integer  "lv",    null: false
  end

  create_table "cafe_worker_councils", force: :cascade do |t|
    t.integer "cafe_worker_id"
    t.integer "council_id"
    t.index ["cafe_worker_id"], name: "index_cafe_worker_councils_on_cafe_worker_id", using: :btree
    t.index ["council_id"], name: "index_cafe_worker_councils_on_council_id", using: :btree
  end

  create_table "cafe_workers", force: :cascade do |t|
    t.integer  "user_id",                                  null: false
    t.integer  "cafe_shift_id",                            null: false
    t.boolean  "competition",               default: true
    t.string   "group",         limit: 255
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["cafe_shift_id"], name: "index_cafe_workers_on_cafe_shift_id", using: :btree
    t.index ["group"], name: "index_cafe_workers_on_group", using: :btree
    t.index ["user_id"], name: "index_cafe_workers_on_user_id", using: :btree
  end

  create_table "candidates", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "election_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.index ["election_id"], name: "index_candidates_on_election_id", using: :btree
    t.index ["post_id"], name: "index_candidates_on_post_id", using: :btree
    t.index ["user_id"], name: "index_candidates_on_user_id", using: :btree
  end

  create_table "car_bans", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "creator_id"
    t.text     "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_car_bans_on_creator_id", using: :btree
    t.index ["user_id"], name: "index_car_bans_on_user_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string   "slug",       limit: 255,                     null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "use_case",               default: "general"
    t.index ["slug"], name: "index_categories_on_slug", using: :btree
  end

  create_table "categorizations", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "categorizable_type", limit: 255, null: false
    t.integer  "categorizable_id",               null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["categorizable_id"], name: "index_categorizations_on_categorizable_id", using: :btree
    t.index ["categorizable_type"], name: "index_categorizations_on_categorizable_type", using: :btree
    t.index ["category_id"], name: "index_categorizations_on_category_id", using: :btree
  end

  create_table "category_translations", force: :cascade do |t|
    t.integer  "category_id", null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "title"
    t.index ["category_id"], name: "index_category_translations_on_category_id", using: :btree
    t.index ["locale"], name: "index_category_translations_on_locale", using: :btree
  end

  create_table "constants", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "value",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_translations", force: :cascade do |t|
    t.integer  "contact_id",             null: false
    t.string   "locale",     limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "name",       limit: 255
    t.text     "text"
    t.index ["contact_id"], name: "index_contact_translations_on_contact_id", using: :btree
    t.index ["locale"], name: "index_contact_translations_on_locale", using: :btree
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.boolean  "public"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",       limit: 255
    t.integer  "post_id"
    t.string   "avatar"
    t.index ["post_id"], name: "index_contacts_on_post_id", using: :btree
    t.index ["slug"], name: "index_contacts_on_slug", using: :btree
  end

  create_table "council_translations", force: :cascade do |t|
    t.integer  "council_id", null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "title"
    t.index ["council_id"], name: "index_council_translations_on_council_id", using: :btree
    t.index ["locale"], name: "index_council_translations_on_locale", using: :btree
  end

  create_table "councils", force: :cascade do |t|
    t.string   "url",          limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "president_id"
    t.index ["president_id"], name: "index_councils_on_president_id", using: :btree
    t.index ["url"], name: "index_councils_on_url", using: :btree
  end

  create_table "documents", force: :cascade do |t|
    t.string   "pdf_file_name",    limit: 255
    t.string   "pdf_content_type", limit: 255
    t.integer  "pdf_file_size"
    t.datetime "pdf_updated_at"
    t.string   "title",            limit: 255
    t.boolean  "public"
    t.boolean  "download"
    t.string   "category",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "slug",             limit: 255
  end

  create_table "doors", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.string   "slug",        limit: 255
    t.text     "description"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "election_posts", force: :cascade do |t|
    t.integer  "election_id"
    t.integer  "post_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["election_id"], name: "index_election_posts_on_election_id", using: :btree
    t.index ["post_id"], name: "index_election_posts_on_post_id", using: :btree
  end

  create_table "election_translations", force: :cascade do |t|
    t.integer  "election_id", null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "title"
    t.text     "description"
    t.index ["election_id"], name: "index_election_translations_on_election_id", using: :btree
    t.index ["locale"], name: "index_election_translations_on_locale", using: :btree
  end

  create_table "elections", force: :cascade do |t|
    t.datetime "open"
    t.datetime "close_general"
    t.boolean  "visible"
    t.string   "url",                 limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "candidate_mail"
    t.text     "nominate_mail"
    t.text     "candidate_mail_star"
    t.string   "mail_link",           limit: 255
    t.string   "board_mail_link",     limit: 255
    t.datetime "close_all"
    t.string   "semester",            limit: 255, default: "spring"
  end

  create_table "event_registrations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.boolean  "reserve",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.text     "answer"
  end

  create_table "event_signup_translations", force: :cascade do |t|
    t.integer  "event_signup_id",                  null: false
    t.string   "locale",               limit: 255, null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "question",             limit: 255
    t.text     "notification_message"
    t.index ["event_signup_id"], name: "index_event_signup_translations_on_event_signup_id", using: :btree
    t.index ["locale"], name: "index_event_signup_translations_on_locale", using: :btree
  end

  create_table "event_signups", force: :cascade do |t|
    t.integer  "event_id"
    t.boolean  "for_members",               default: true, null: false
    t.string   "question",      limit: 255
    t.integer  "slots",                                    null: false
    t.datetime "closes",                                   null: false
    t.datetime "opens",                                    null: false
    t.integer  "novice"
    t.integer  "mentor"
    t.integer  "member"
    t.integer  "custom"
    t.string   "custom_name",   limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "group_types"
    t.datetime "sent_reminder"
    t.datetime "sent_position"
    t.datetime "sent_closing"
    t.index ["deleted_at"], name: "index_event_signups_on_deleted_at", using: :btree
    t.index ["event_id"], name: "index_event_signups_on_event_id", using: :btree
  end

  create_table "event_translations", force: :cascade do |t|
    t.integer  "event_id",                null: false
    t.string   "locale",      limit: 255, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "title",       limit: 255
    t.text     "description"
    t.string   "short",       limit: 255
    t.string   "location",    limit: 255
    t.index ["event_id"], name: "index_event_translations_on_event_id", using: :btree
    t.index ["locale"], name: "index_event_translations_on_locale", using: :btree
  end

  create_table "event_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "group_id"
    t.text     "answer"
    t.string   "user_type",    limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "group_custom"
    t.index ["deleted_at"], name: "index_event_users_on_deleted_at", using: :btree
    t.index ["event_id"], name: "index_event_users_on_event_id", using: :btree
    t.index ["group_id"], name: "index_event_users_on_group_id", using: :btree
    t.index ["user_id"], name: "index_event_users_on_user_id", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.text     "description"
    t.string   "location",        limit: 255
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean  "all_day"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name", limit: 255
    t.integer  "council_id"
    t.string   "short",           limit: 255
    t.string   "dot",             limit: 255
    t.boolean  "drink"
    t.boolean  "food"
    t.boolean  "cash"
    t.datetime "deleted_at"
    t.integer  "price"
    t.string   "dress_code",      limit: 255
    t.integer  "contact_id"
  end

  create_table "faqs", force: :cascade do |t|
    t.string   "question",      limit: 255
    t.text     "answer"
    t.integer  "sorting_index"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category",      limit: 255
    t.index ["category"], name: "index_faqs_on_category", using: :btree
  end

  create_table "fredmanskies", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_fredmanskies_on_user_id", using: :btree
  end

  create_table "group_messages", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "message_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_group_messages_on_deleted_at", using: :btree
    t.index ["group_id"], name: "index_group_messages_on_group_id", using: :btree
    t.index ["message_id"], name: "index_group_messages_on_message_id", using: :btree
  end

  create_table "group_users", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.boolean  "fadder",       default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "unread_count", default: 0,     null: false
    t.index ["deleted_at"], name: "index_group_users_on_deleted_at", using: :btree
    t.index ["group_id"], name: "index_group_users_on_group_id", using: :btree
    t.index ["user_id"], name: "index_group_users_on_user_id", using: :btree
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "number"
    t.integer  "introduction_id"
    t.datetime "deleted_at"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "group_type",      limit: 255, default: "regular", null: false
    t.index ["deleted_at"], name: "index_groups_on_deleted_at", using: :btree
    t.index ["introduction_id"], name: "index_groups_on_introduction_id", using: :btree
  end

  create_table "images", force: :cascade do |t|
    t.integer  "album_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file",              limit: 255
    t.string   "filename",          limit: 255
    t.integer  "photographer_id"
    t.string   "photographer_name", limit: 255
    t.integer  "width"
    t.integer  "height"
    t.string   "file_tmp"
    t.index ["album_id"], name: "index_images_on_album_id", using: :btree
    t.index ["file"], name: "index_images_on_file", using: :btree
    t.index ["filename"], name: "index_images_on_filename", using: :btree
    t.index ["photographer_id"], name: "index_images_on_photographer_id", using: :btree
  end

  create_table "introduction_translations", force: :cascade do |t|
    t.integer  "introduction_id",             null: false
    t.string   "locale",          limit: 255, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "title",           limit: 255
    t.text     "description"
    t.index ["introduction_id"], name: "index_introduction_translations_on_introduction_id", using: :btree
    t.index ["locale"], name: "index_introduction_translations_on_locale", using: :btree
  end

  create_table "introductions", force: :cascade do |t|
    t.string   "title",       limit: 255, default: "",   null: false
    t.datetime "start",                                  null: false
    t.datetime "stop",                                   null: false
    t.string   "slug",        limit: 255,                null: false
    t.text     "description"
    t.boolean  "current",                 default: true, null: false
    t.datetime "deleted_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.index ["deleted_at"], name: "index_introductions_on_deleted_at", using: :btree
    t.index ["slug"], name: "index_introductions_on_slug", using: :btree
  end

  create_table "mail_aliases", force: :cascade do |t|
    t.string   "username",   limit: 255, null: false
    t.string   "domain",     limit: 255, null: false
    t.string   "target",     limit: 255, null: false
    t.datetime "updated_at",             null: false
    t.index ["target"], name: "index_mail_aliases_on_target", using: :btree
    t.index ["username", "domain", "target"], name: "index_mail_aliases_on_username_and_domain_and_target", unique: true, using: :btree
  end

  create_table "main_menu_translations", force: :cascade do |t|
    t.integer  "main_menu_id",             null: false
    t.string   "locale",       limit: 255, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "name",         limit: 255
    t.index ["locale"], name: "index_main_menu_translations_on_locale", using: :btree
    t.index ["main_menu_id"], name: "index_main_menu_translations_on_main_menu_id", using: :btree
  end

  create_table "main_menus", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "index"
    t.boolean  "mega",                   default: true,  null: false
    t.boolean  "fw",                     default: false, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "visible",                default: true,  null: false
  end

  create_table "meetings", force: :cascade do |t|
    t.datetime "start_date",                 null: false
    t.datetime "end_date",                   null: false
    t.string   "title",                      null: false
    t.text     "purpose"
    t.text     "comment"
    t.integer  "user_id"
    t.integer  "council_id"
    t.boolean  "by_admin",   default: false, null: false
    t.integer  "status",     default: 0
    t.integer  "room",       default: 0
    t.index ["council_id"], name: "index_meetings_on_council_id", using: :btree
    t.index ["end_date"], name: "index_meetings_on_end_date", using: :btree
    t.index ["start_date"], name: "index_meetings_on_start_date", using: :btree
    t.index ["user_id"], name: "index_meetings_on_user_id", using: :btree
  end

  create_table "menu_translations", force: :cascade do |t|
    t.integer  "menu_id",                null: false
    t.string   "locale",     limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "name",       limit: 255
    t.index ["locale"], name: "index_menu_translations_on_locale", using: :btree
    t.index ["menu_id"], name: "index_menu_translations_on_menu_id", using: :btree
  end

  create_table "menus", force: :cascade do |t|
    t.integer  "index"
    t.string   "link",         limit: 255
    t.string   "name",         limit: 255
    t.boolean  "visible",                  default: true
    t.boolean  "turbolinks",               default: true
    t.boolean  "blank_p"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "header",                   default: false, null: false
    t.integer  "column",                   default: 1,     null: false
    t.integer  "main_menu_id"
    t.index ["main_menu_id"], name: "index_menus_on_main_menu_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "content",                                null: false
    t.datetime "deleted_at"
    t.integer  "message_comments_count", default: 0,     null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "by_admin",               default: false, null: false
    t.integer  "introduction_id"
    t.bigint   "sent_at",                                null: false
    t.index ["deleted_at"], name: "index_messages_on_deleted_at", using: :btree
    t.index ["introduction_id"], name: "index_messages_on_introduction_id", using: :btree
    t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
  end

  create_table "news", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "image",       limit: 255
    t.datetime "pinned_from"
    t.datetime "pinned_to"
  end

  create_table "news_translations", force: :cascade do |t|
    t.integer  "news_id",                null: false
    t.string   "locale",     limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "title",      limit: 255
    t.text     "content"
    t.index ["locale"], name: "index_news_translations_on_locale", using: :btree
    t.index ["news_id"], name: "index_news_translations_on_news_id", using: :btree
  end

  create_table "nominations", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "election_id"
    t.string   "name",        limit: 255
    t.string   "email",       limit: 255
    t.text     "motivation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notice_translations", force: :cascade do |t|
    t.integer  "notice_id",               null: false
    t.string   "locale",      limit: 255, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "title",       limit: 255
    t.text     "description"
    t.index ["locale"], name: "index_notice_translations_on_locale", using: :btree
    t.index ["notice_id"], name: "index_notice_translations_on_notice_id", using: :btree
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "seen",            default: false, null: false
    t.string   "notifyable_type",                 null: false
    t.integer  "notifyable_id",                   null: false
    t.string   "mode",                            null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["notifyable_id"], name: "index_notifications_on_notifyable_id", using: :btree
    t.index ["notifyable_type"], name: "index_notifications_on_notifyable_type", using: :btree
    t.index ["user_id"], name: "index_notifications_on_user_id", using: :btree
  end

  create_table "page_element_translations", force: :cascade do |t|
    t.integer  "page_element_id",             null: false
    t.string   "locale",          limit: 255, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.text     "text"
    t.string   "headline",        limit: 255
    t.index ["locale"], name: "index_page_element_translations_on_locale", using: :btree
    t.index ["page_element_id"], name: "index_page_element_translations_on_page_element_id", using: :btree
  end

  create_table "page_elements", force: :cascade do |t|
    t.integer  "index",                     default: 1
    t.boolean  "sidebar"
    t.boolean  "visible",                   default: true
    t.text     "text"
    t.string   "headline",      limit: 255
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "element_type",  limit: 255, default: "text", null: false
    t.integer  "page_image_id"
    t.integer  "contact_id"
    t.index ["page_id"], name: "index_page_elements_on_page_id", using: :btree
  end

  create_table "page_images", force: :cascade do |t|
    t.integer  "page_id"
    t.string   "image",      limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["page_id"], name: "index_page_images_on_page_id", using: :btree
  end

  create_table "page_translations", force: :cascade do |t|
    t.integer  "page_id",                             null: false
    t.string   "locale",     limit: 255,              null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "title",      limit: 255, default: ""
    t.index ["locale"], name: "index_page_translations_on_locale", using: :btree
    t.index ["page_id"], name: "index_page_translations_on_page_id", using: :btree
  end

  create_table "pages", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "council_id"
    t.string   "url",        limit: 255
    t.boolean  "visible"
    t.string   "title",      limit: 255
    t.boolean  "public",                 default: true, null: false
    t.string   "namespace",  limit: 255
    t.index ["council_id"], name: "index_pages_on_council_id", using: :btree
    t.index ["url"], name: "index_pages_on_url", using: :btree
  end

  create_table "permission_posts", force: :cascade do |t|
    t.integer  "permission_id"
    t.integer  "post_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "subject_class", limit: 255
    t.string   "action",        limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "post_translations", force: :cascade do |t|
    t.integer  "post_id",     null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "title"
    t.text     "description"
    t.index ["locale"], name: "index_post_translations_on_locale", using: :btree
    t.index ["post_id"], name: "index_post_translations_on_post_id", using: :btree
  end

  create_table "post_users", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "limit",                  default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "council_id"
    t.string   "elected_by", limit: 255
    t.string   "semester",   limit: 255, default: "both"
    t.boolean  "board"
    t.integer  "rec_limit",              default: 0
    t.boolean  "car_rent"
  end

  create_table "push_devices", force: :cascade do |t|
    t.string  "token",               null: false
    t.integer "system",  default: 0, null: false
    t.integer "user_id"
    t.index ["token", "user_id"], name: "index_push_devices_on_token_and_user_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_push_devices_on_user_id", using: :btree
  end

  create_table "rents", force: :cascade do |t|
    t.datetime "d_from"
    t.datetime "d_til"
    t.text     "purpose"
    t.boolean  "aktiv",                  default: true
    t.integer  "council_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment"
    t.string   "status",     limit: 255, default: "unconfirmed"
    t.boolean  "service",                default: false
    t.integer  "user_id"
    t.index ["council_id"], name: "index_rents_on_council_id", using: :btree
    t.index ["user_id"], name: "index_rents_on_user_id", using: :btree
  end

  create_table "rpush_apps", force: :cascade do |t|
    t.string   "name",                                null: false
    t.string   "environment"
    t.text     "certificate"
    t.string   "password"
    t.integer  "connections",             default: 1, null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "type",                                null: false
    t.string   "auth_key"
    t.string   "client_id"
    t.string   "client_secret"
    t.string   "access_token"
    t.datetime "access_token_expiration"
  end

  create_table "rpush_feedback", force: :cascade do |t|
    t.string   "device_token", limit: 64, null: false
    t.datetime "failed_at",               null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "app_id"
    t.index ["device_token"], name: "index_rpush_feedback_on_device_token", using: :btree
  end

  create_table "rpush_notifications", force: :cascade do |t|
    t.integer  "badge"
    t.string   "device_token",      limit: 64
    t.string   "sound"
    t.text     "alert"
    t.text     "data"
    t.integer  "expiry",                       default: 86400
    t.boolean  "delivered",                    default: false, null: false
    t.datetime "delivered_at"
    t.boolean  "failed",                       default: false, null: false
    t.datetime "failed_at"
    t.integer  "error_code"
    t.text     "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.boolean  "alert_is_json",                default: false, null: false
    t.string   "type",                                         null: false
    t.string   "collapse_key"
    t.boolean  "delay_while_idle",             default: false, null: false
    t.text     "registration_ids"
    t.integer  "app_id",                                       null: false
    t.integer  "retries",                      default: 0
    t.string   "uri"
    t.datetime "fail_after"
    t.boolean  "processing",                   default: false, null: false
    t.integer  "priority"
    t.text     "url_args"
    t.string   "category"
    t.boolean  "content_available",            default: false, null: false
    t.text     "notification"
    t.boolean  "mutable_content",              default: false, null: false
    t.index ["delivered", "failed"], name: "index_rpush_notifications_multi", where: "((NOT delivered) AND (NOT failed))", using: :btree
  end

  create_table "short_links", force: :cascade do |t|
    t.string "link",   limit: 255, null: false
    t.text   "target",             null: false
    t.index ["link"], name: "index_short_links_on_link", using: :btree
  end

  create_table "songs", force: :cascade do |t|
    t.string  "title",                null: false
    t.string  "author"
    t.string  "melody"
    t.string  "category"
    t.text    "content"
    t.integer "visits",   default: 0
  end

  create_table "tool_rentings", force: :cascade do |t|
    t.string   "renter",      limit: 255,                 null: false
    t.string   "purpose",     limit: 255
    t.integer  "tool_id",                                 null: false
    t.date     "return_date",                             null: false
    t.boolean  "returned",                default: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.index ["renter"], name: "index_tool_rentings_on_renter", using: :btree
    t.index ["tool_id"], name: "index_tool_rentings_on_tool_id", using: :btree
  end

  create_table "tools", force: :cascade do |t|
    t.string   "title",       limit: 255,             null: false
    t.text     "description",                         null: false
    t.integer  "total",                   default: 1
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",      null: false
    t.string   "encrypted_password",     limit: 255, default: "",      null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "firstname",              limit: 255
    t.string   "lastname",               limit: 255
    t.string   "phone",                  limit: 255
    t.integer  "first_post_id"
    t.string   "avatar_file_name",       limit: 255
    t.string   "avatar_content_type",    limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "start_year"
    t.string   "program",                limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "member_at"
    t.string   "food_custom",            limit: 255
    t.string   "student_id",             limit: 255
    t.boolean  "display_phone",                      default: false,   null: false
    t.string   "food_preferences"
    t.string   "provider",                           default: "email", null: false
    t.string   "uid",                                default: "",      null: false
    t.text     "tokens"
    t.integer  "notifications_count",                default: 0,       null: false
    t.boolean  "notify_event_users",                 default: true,    null: false
    t.boolean  "notify_messages",                    default: true,    null: false
    t.boolean  "notify_event_closing",               default: false,   null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
  end

  create_table "work_posts", force: :cascade do |t|
    t.string   "title",        limit: 255
    t.text     "description"
    t.string   "company",      limit: 255
    t.datetime "deadline"
    t.string   "target_group", limit: 255
    t.boolean  "visible",                  default: true
    t.datetime "publish"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link",         limit: 255
    t.string   "kind",         limit: 255
    t.string   "image",        limit: 255
    t.string   "field",        limit: 255
    t.index ["field"], name: "index_work_posts_on_field", using: :btree
    t.index ["target_group"], name: "index_work_posts_on_target_group", using: :btree
    t.index ["user_id"], name: "index_work_posts_on_user_id", using: :btree
  end

  add_foreign_key "accesses", "doors"
  add_foreign_key "accesses", "posts"
  add_foreign_key "achievement_users", "achievements"
  add_foreign_key "achievement_users", "users"
  add_foreign_key "adventure_groups", "adventures"
  add_foreign_key "adventure_groups", "groups"
  add_foreign_key "adventures", "introductions"
  add_foreign_key "blog_posts", "users"
  add_foreign_key "candidates", "elections"
  add_foreign_key "candidates", "posts"
  add_foreign_key "candidates", "users"
  add_foreign_key "car_bans", "users"
  add_foreign_key "car_bans", "users", column: "creator_id"
  add_foreign_key "categorizations", "categories"
  add_foreign_key "election_posts", "elections"
  add_foreign_key "election_posts", "posts"
  add_foreign_key "event_signups", "events"
  add_foreign_key "event_users", "events"
  add_foreign_key "event_users", "users"
  add_foreign_key "events", "contacts"
  add_foreign_key "fredmanskies", "users"
  add_foreign_key "group_messages", "groups"
  add_foreign_key "group_messages", "messages"
  add_foreign_key "group_users", "groups"
  add_foreign_key "group_users", "users"
  add_foreign_key "meetings", "councils"
  add_foreign_key "meetings", "users"
  add_foreign_key "menus", "main_menus"
  add_foreign_key "messages", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "page_images", "pages"
  add_foreign_key "push_devices", "users"
  add_foreign_key "rents", "users"
end
