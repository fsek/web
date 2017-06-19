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

ActiveRecord::Schema.define(version: 20170823132130) do

  create_table "accesses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "door_id"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["door_id"], name: "index_accesses_on_door_id", using: :btree
    t.index ["post_id"], name: "index_accesses_on_post_id", using: :btree
  end

  create_table "adventure_groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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

  create_table "adventure_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "adventure_id",               null: false
    t.string   "locale",                     null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "title"
    t.text     "content",      limit: 65535
    t.index ["adventure_id"], name: "index_adventure_translations_on_adventure_id", using: :btree
    t.index ["locale"], name: "index_adventure_translations_on_locale", using: :btree
  end

  create_table "adventures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.text     "content",         limit: 65535
    t.integer  "max_points",                                    null: false
    t.integer  "introduction_id"
    t.boolean  "publish_results",               default: false, null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "deleted_at"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "video"
    t.index ["deleted_at"], name: "index_adventures_on_deleted_at", using: :btree
    t.index ["end_date"], name: "index_adventures_on_end_date", using: :btree
    t.index ["introduction_id"], name: "index_adventures_on_introduction_id", using: :btree
    t.index ["start_date"], name: "index_adventures_on_start_date", using: :btree
  end

  create_table "album_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "album_id",                  null: false
    t.string   "locale",                    null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "title"
    t.text     "description", limit: 65535
    t.index ["album_id"], name: "index_album_translations_on_album_id", using: :btree
    t.index ["locale"], name: "index_album_translations_on_locale", using: :btree
  end

  create_table "albums", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.text     "description",  limit: 65535
    t.string   "location"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
    t.integer  "images_count",               default: 0, null: false
  end

  create_table "blog_post_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "blog_post_id",               null: false
    t.string   "locale",                     null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "title"
    t.text     "preamble",     limit: 65535
    t.text     "content",      limit: 65535
    t.index ["blog_post_id"], name: "index_blog_post_translations_on_blog_post_id", using: :btree
    t.index ["locale"], name: "index_blog_post_translations_on_locale", using: :btree
  end

  create_table "blog_posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "preamble",    limit: 65535
    t.text     "content",     limit: 65535
    t.datetime "deleted_at"
    t.string   "cover_image"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["deleted_at"], name: "index_blog_posts_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_blog_posts_on_user_id", using: :btree
  end

  create_table "cafe_shifts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "start", null: false
    t.integer  "pass",  null: false
    t.integer  "lp",    null: false
    t.integer  "lv",    null: false
  end

  create_table "cafe_worker_councils", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "cafe_worker_id"
    t.integer "council_id"
    t.index ["cafe_worker_id"], name: "index_cafe_worker_councils_on_cafe_worker_id", using: :btree
    t.index ["council_id"], name: "index_cafe_worker_councils_on_council_id", using: :btree
  end

  create_table "cafe_workers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",                      null: false
    t.integer  "cafe_shift_id",                null: false
    t.boolean  "competition",   default: true
    t.string   "group"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["cafe_shift_id"], name: "index_cafe_workers_on_cafe_shift_id", using: :btree
    t.index ["group"], name: "index_cafe_workers_on_group", using: :btree
    t.index ["user_id"], name: "index_cafe_workers_on_user_id", using: :btree
  end

  create_table "candidates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "post_id"
    t.integer  "election_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.index ["election_id"], name: "index_candidates_on_election_id", using: :btree
    t.index ["post_id"], name: "index_candidates_on_post_id", using: :btree
    t.index ["user_id"], name: "index_candidates_on_user_id", using: :btree
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "slug",                           null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "use_case",   default: "general"
    t.index ["slug"], name: "index_categories_on_slug", using: :btree
  end

  create_table "categorizations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "category_id"
    t.string   "categorizable_type", null: false
    t.integer  "categorizable_id",   null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["categorizable_id"], name: "index_categorizations_on_categorizable_id", using: :btree
    t.index ["categorizable_type"], name: "index_categorizations_on_categorizable_type", using: :btree
    t.index ["category_id"], name: "index_categorizations_on_category_id", using: :btree
  end

  create_table "category_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "category_id", null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "title"
    t.index ["category_id"], name: "index_category_translations_on_category_id", using: :btree
    t.index ["locale"], name: "index_category_translations_on_locale", using: :btree
  end

  create_table "constants", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "contact_id",               null: false
    t.string   "locale",                   null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "name"
    t.text     "text",       limit: 65535
    t.index ["contact_id"], name: "index_contact_translations_on_contact_id", using: :btree
    t.index ["locale"], name: "index_contact_translations_on_locale", using: :btree
  end

  create_table "contacts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "email"
    t.boolean  "public"
    t.text     "text",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "post_id"
    t.string   "avatar"
    t.index ["post_id"], name: "index_contacts_on_post_id", using: :btree
    t.index ["slug"], name: "index_contacts_on_slug", using: :btree
  end

  create_table "council_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "council_id", null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "title"
    t.index ["council_id"], name: "index_council_translations_on_council_id", using: :btree
    t.index ["locale"], name: "index_council_translations_on_locale", using: :btree
  end

  create_table "councils", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "url"
    t.text     "description",  limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "president_id"
    t.index ["president_id"], name: "index_councils_on_president_id", using: :btree
    t.index ["url"], name: "index_councils_on_url", using: :btree
  end

  create_table "documents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "pdf_file_name"
    t.string   "pdf_content_type"
    t.integer  "pdf_file_size"
    t.datetime "pdf_updated_at"
    t.string   "title"
    t.boolean  "public"
    t.boolean  "download"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "slug"
  end

  create_table "doors", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "election_posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "election_id"
    t.integer  "post_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["election_id"], name: "index_election_posts_on_election_id", using: :btree
    t.index ["post_id"], name: "index_election_posts_on_post_id", using: :btree
  end

  create_table "election_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "election_id",               null: false
    t.string   "locale",                    null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "title"
    t.text     "description", limit: 65535
    t.index ["election_id"], name: "index_election_translations_on_election_id", using: :btree
    t.index ["locale"], name: "index_election_translations_on_locale", using: :btree
  end

  create_table "elections", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "open"
    t.datetime "close_general"
    t.boolean  "visible"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "candidate_mail",      limit: 65535
    t.text     "nominate_mail",       limit: 65535
    t.text     "candidate_mail_star", limit: 65535
    t.string   "mail_link"
    t.string   "board_mail_link"
    t.datetime "close_all"
    t.string   "semester",                          default: "spring"
  end

  create_table "event_registrations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.boolean  "reserve",                  default: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.text     "answer",     limit: 65535
  end

  create_table "event_signup_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "event_signup_id",      null: false
    t.string   "locale",               null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "question"
    t.string   "notification_message"
    t.index ["event_signup_id"], name: "index_event_signup_translations_on_event_signup_id", using: :btree
    t.index ["locale"], name: "index_event_signup_translations_on_locale", using: :btree
  end

  create_table "event_signups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "event_id"
    t.boolean  "for_members",   default: true, null: false
    t.string   "question"
    t.integer  "slots",                        null: false
    t.datetime "closes",                       null: false
    t.datetime "opens",                        null: false
    t.integer  "novice"
    t.integer  "mentor"
    t.integer  "member"
    t.integer  "custom"
    t.string   "custom_name"
    t.datetime "deleted_at"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "group_types"
    t.datetime "sent_reminder"
    t.datetime "sent_position"
    t.index ["deleted_at"], name: "index_event_signups_on_deleted_at", using: :btree
    t.index ["event_id"], name: "index_event_signups_on_event_id", using: :btree
  end

  create_table "event_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "event_id",                  null: false
    t.string   "locale",                    null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "title"
    t.text     "description", limit: 65535
    t.string   "short"
    t.string   "location"
    t.index ["event_id"], name: "index_event_translations_on_event_id", using: :btree
    t.index ["locale"], name: "index_event_translations_on_locale", using: :btree
  end

  create_table "event_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "group_id"
    t.text     "answer",       limit: 65535
    t.string   "user_type"
    t.datetime "deleted_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "group_custom"
    t.index ["deleted_at"], name: "index_event_users_on_deleted_at", using: :btree
    t.index ["event_id"], name: "index_event_users_on_event_id", using: :btree
    t.index ["group_id"], name: "index_event_users_on_group_id", using: :btree
    t.index ["user_id"], name: "index_event_users_on_user_id", using: :btree
  end

  create_table "events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.text     "description",     limit: 65535
    t.string   "location"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean  "all_day"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.integer  "council_id"
    t.string   "short"
    t.string   "dot"
    t.boolean  "drink"
    t.boolean  "food"
    t.boolean  "cash"
    t.datetime "deleted_at"
    t.integer  "price"
    t.string   "dress_code"
    t.integer  "contact_id"
    t.index ["contact_id"], name: "fk_rails_76717d1c49", using: :btree
  end

  create_table "faqs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "question"
    t.text     "answer",        limit: 65535
    t.integer  "sorting_index"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
    t.index ["category"], name: "index_faqs_on_category", using: :btree
  end

  create_table "group_messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "group_id"
    t.integer  "message_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_group_messages_on_deleted_at", using: :btree
    t.index ["group_id"], name: "index_group_messages_on_group_id", using: :btree
    t.index ["message_id"], name: "index_group_messages_on_message_id", using: :btree
  end

  create_table "group_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.boolean  "fadder",     default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["deleted_at"], name: "index_group_users_on_deleted_at", using: :btree
    t.index ["group_id"], name: "index_group_users_on_group_id", using: :btree
    t.index ["user_id"], name: "index_group_users_on_user_id", using: :btree
  end

  create_table "groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "number"
    t.integer  "introduction_id"
    t.datetime "deleted_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "group_type",      default: "regular", null: false
    t.index ["deleted_at"], name: "index_groups_on_deleted_at", using: :btree
    t.index ["introduction_id"], name: "index_groups_on_introduction_id", using: :btree
  end

  create_table "images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "album_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file"
    t.string   "filename"
    t.integer  "photographer_id"
    t.string   "photographer_name"
    t.integer  "width"
    t.integer  "height"
    t.string   "file_tmp"
    t.index ["album_id"], name: "index_images_on_album_id", using: :btree
    t.index ["file"], name: "index_images_on_file", using: :btree
    t.index ["filename"], name: "index_images_on_filename", using: :btree
    t.index ["photographer_id"], name: "index_images_on_photographer_id", using: :btree
  end

  create_table "introduction_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "introduction_id",               null: false
    t.string   "locale",                        null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "title"
    t.text     "description",     limit: 65535
    t.index ["introduction_id"], name: "index_introduction_translations_on_introduction_id", using: :btree
    t.index ["locale"], name: "index_introduction_translations_on_locale", using: :btree
  end

  create_table "introductions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title",                     default: "",   null: false
    t.datetime "start",                                    null: false
    t.datetime "stop",                                     null: false
    t.string   "slug",                                     null: false
    t.text     "description", limit: 65535
    t.boolean  "current",                   default: true, null: false
    t.datetime "deleted_at"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["deleted_at"], name: "index_introductions_on_deleted_at", using: :btree
    t.index ["slug"], name: "index_introductions_on_slug", using: :btree
  end

  create_table "mail_aliases", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "username",   null: false
    t.string   "domain",     null: false
    t.string   "target",     null: false
    t.datetime "updated_at", null: false
    t.index ["target"], name: "index_mail_aliases_on_target", using: :btree
    t.index ["username", "domain", "target"], name: "index_mail_aliases_on_username_and_domain_and_target", unique: true, using: :btree
  end

  create_table "main_menu_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "main_menu_id", null: false
    t.string   "locale",       null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "name"
    t.index ["locale"], name: "index_main_menu_translations_on_locale", using: :btree
    t.index ["main_menu_id"], name: "index_main_menu_translations_on_main_menu_id", using: :btree
  end

  create_table "main_menus", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "index"
    t.boolean  "mega",       default: true,  null: false
    t.boolean  "fw",         default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "meetings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "start_date",                               null: false
    t.datetime "end_date",                                 null: false
    t.string   "title",                                    null: false
    t.text     "purpose",    limit: 65535
    t.text     "comment",    limit: 65535
    t.integer  "user_id"
    t.integer  "council_id"
    t.boolean  "by_admin",                 default: false, null: false
    t.integer  "status",                   default: 0
    t.integer  "room",                     default: 0
    t.index ["council_id"], name: "index_meetings_on_council_id", using: :btree
    t.index ["end_date"], name: "index_meetings_on_end_date", using: :btree
    t.index ["start_date"], name: "index_meetings_on_start_date", using: :btree
    t.index ["user_id"], name: "index_meetings_on_user_id", using: :btree
  end

  create_table "menu_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "menu_id",    null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.index ["locale"], name: "index_menu_translations_on_locale", using: :btree
    t.index ["menu_id"], name: "index_menu_translations_on_menu_id", using: :btree
  end

  create_table "menus", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "index"
    t.string   "link"
    t.string   "name"
    t.boolean  "visible",      default: true
    t.boolean  "turbolinks",   default: true
    t.boolean  "blank_p"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "header",       default: false, null: false
    t.integer  "column",       default: 1,     null: false
    t.integer  "main_menu_id"
    t.index ["main_menu_id"], name: "index_menus_on_main_menu_id", using: :btree
  end

  create_table "message_comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "message_id"
    t.integer  "user_id"
    t.text     "content",    limit: 65535,                 null: false
    t.datetime "deleted_at"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "by_admin",                 default: false, null: false
    t.index ["deleted_at"], name: "index_message_comments_on_deleted_at", using: :btree
    t.index ["message_id"], name: "index_message_comments_on_message_id", using: :btree
    t.index ["user_id"], name: "index_message_comments_on_user_id", using: :btree
  end

  create_table "messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.text     "content",                limit: 65535,                 null: false
    t.datetime "deleted_at"
    t.integer  "message_comments_count",               default: 0,     null: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.boolean  "by_admin",                             default: false, null: false
    t.integer  "introduction_id"
    t.index ["deleted_at"], name: "index_messages_on_deleted_at", using: :btree
    t.index ["introduction_id"], name: "index_messages_on_introduction_id", using: :btree
    t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
  end

  create_table "news", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.text     "content",     limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "image"
    t.datetime "pinned_from"
    t.datetime "pinned_to"
  end

  create_table "news_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "news_id",                  null: false
    t.string   "locale",                   null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "title"
    t.text     "content",    limit: 65535
    t.index ["locale"], name: "index_news_translations_on_locale", using: :btree
    t.index ["news_id"], name: "index_news_translations_on_news_id", using: :btree
  end

  create_table "nominations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "post_id"
    t.integer  "election_id"
    t.string   "name"
    t.string   "email"
    t.text     "motivation",  limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notice_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "notice_id",                 null: false
    t.string   "locale",                    null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "title"
    t.text     "description", limit: 65535
    t.index ["locale"], name: "index_notice_translations_on_locale", using: :btree
    t.index ["notice_id"], name: "index_notice_translations_on_notice_id", using: :btree
  end

  create_table "notices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.text     "description", limit: 65535
    t.boolean  "public"
    t.datetime "d_publish"
    t.datetime "d_remove"
    t.integer  "sort"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",                   null: false
  end

  create_table "notifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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

  create_table "page_element_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "page_element_id",               null: false
    t.string   "locale",                        null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.text     "text",            limit: 65535
    t.string   "headline"
    t.index ["locale"], name: "index_page_element_translations_on_locale", using: :btree
    t.index ["page_element_id"], name: "index_page_element_translations_on_page_element_id", using: :btree
  end

  create_table "page_elements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "index",                       default: 1
    t.boolean  "sidebar"
    t.boolean  "visible",                     default: true
    t.text     "text",          limit: 65535
    t.string   "headline"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "element_type",                default: "text", null: false
    t.integer  "page_image_id"
    t.integer  "contact_id"
    t.index ["page_id"], name: "index_page_elements_on_page_id", using: :btree
  end

  create_table "page_images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "page_id"
    t.string   "image",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_page_images_on_page_id", using: :btree
  end

  create_table "page_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "page_id",                 null: false
    t.string   "locale",                  null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "title",      default: ""
    t.index ["locale"], name: "index_page_translations_on_locale", using: :btree
    t.index ["page_id"], name: "index_page_translations_on_page_id", using: :btree
  end

  create_table "pages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "council_id"
    t.string   "url"
    t.boolean  "visible"
    t.string   "title"
    t.boolean  "public",     default: true, null: false
    t.string   "namespace"
    t.index ["council_id"], name: "index_pages_on_council_id", using: :btree
    t.index ["url"], name: "index_pages_on_url", using: :btree
  end

  create_table "permission_posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "permission_id"
    t.integer  "post_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "permissions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "subject_class"
    t.string   "action"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "post_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "post_id",                   null: false
    t.string   "locale",                    null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "title"
    t.text     "description", limit: 65535
    t.index ["locale"], name: "index_post_translations_on_locale", using: :btree
    t.index ["post_id"], name: "index_post_translations_on_post_id", using: :btree
  end

  create_table "post_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "limit",      default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "council_id"
    t.string   "elected_by"
    t.string   "semester",   default: "both"
    t.boolean  "board"
    t.integer  "rec_limit",  default: 0
    t.boolean  "car_rent"
  end

  create_table "rents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "d_from"
    t.datetime "d_til"
    t.text     "purpose",    limit: 65535
    t.boolean  "aktiv",                    default: true
    t.integer  "council_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment",    limit: 65535
    t.string   "status",                   default: "unconfirmed"
    t.boolean  "service",                  default: false
    t.integer  "user_id"
    t.index ["council_id"], name: "index_rents_on_council_id", using: :btree
    t.index ["user_id"], name: "index_rents_on_user_id", using: :btree
  end

  create_table "short_links", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "link",                 null: false
    t.text   "target", limit: 65535, null: false
    t.index ["link"], name: "index_short_links_on_link", using: :btree
  end

  create_table "songs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "title",                              null: false
    t.string  "author"
    t.string  "melody"
    t.string  "category"
    t.text    "content",  limit: 65535
    t.integer "visits",                 default: 0
  end

  create_table "tool_rentings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "renter",                      null: false
    t.string   "purpose"
    t.integer  "tool_id",                     null: false
    t.date     "return_date",                 null: false
    t.boolean  "returned",    default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["renter"], name: "index_tool_rentings_on_renter", using: :btree
    t.index ["tool_id"], name: "index_tool_rentings_on_tool_id", using: :btree
  end

  create_table "tools", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title",                                 null: false
    t.text     "description", limit: 65535,             null: false
    t.integer  "total",                     default: 1
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "phone"
    t.integer  "first_post_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "start_year"
    t.string   "program"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "member_at"
    t.string   "food_custom"
    t.string   "student_id"
    t.boolean  "display_phone",          default: false, null: false
    t.string   "food_preferences"
    t.integer  "notifications_count",    default: 0,     null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "work_posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.text     "description",  limit: 65535
    t.string   "company"
    t.datetime "deadline"
    t.string   "target_group"
    t.boolean  "visible",                    default: true
    t.datetime "publish"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link"
    t.string   "kind"
    t.string   "image"
    t.string   "field"
    t.index ["field"], name: "index_work_posts_on_field", using: :btree
    t.index ["target_group"], name: "index_work_posts_on_target_group", using: :btree
    t.index ["user_id"], name: "index_work_posts_on_user_id", using: :btree
  end

  add_foreign_key "accesses", "doors"
  add_foreign_key "accesses", "posts"
  add_foreign_key "adventure_groups", "adventures"
  add_foreign_key "adventure_groups", "groups"
  add_foreign_key "adventures", "introductions"
  add_foreign_key "blog_posts", "users"
  add_foreign_key "candidates", "elections"
  add_foreign_key "candidates", "posts"
  add_foreign_key "candidates", "users"
  add_foreign_key "categorizations", "categories"
  add_foreign_key "election_posts", "elections"
  add_foreign_key "election_posts", "posts"
  add_foreign_key "event_signups", "events"
  add_foreign_key "event_users", "events"
  add_foreign_key "event_users", "users"
  add_foreign_key "events", "contacts"
  add_foreign_key "group_messages", "groups"
  add_foreign_key "group_messages", "messages"
  add_foreign_key "group_users", "groups"
  add_foreign_key "group_users", "users"
  add_foreign_key "meetings", "councils"
  add_foreign_key "meetings", "users"
  add_foreign_key "menus", "main_menus"
  add_foreign_key "message_comments", "messages"
  add_foreign_key "message_comments", "users"
  add_foreign_key "messages", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "page_images", "pages"
  add_foreign_key "rents", "users"
end
