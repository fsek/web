class InitSchema < ActiveRecord::Migration
  def up
    
    create_table "accesses", force: :cascade do |t|
      t.integer  "door_id",    limit: 4
      t.integer  "post_id",    limit: 4
      t.datetime "created_at",           null: false
      t.datetime "updated_at",           null: false
    end
    
    add_index "accesses", ["door_id"], name: "index_accesses_on_door_id", using: :btree
    add_index "accesses", ["post_id"], name: "index_accesses_on_post_id", using: :btree
    
    create_table "adventure_groups", force: :cascade do |t|
      t.integer  "points",       limit: 4, default: 0, null: false
      t.integer  "adventure_id", limit: 4
      t.integer  "group_id",     limit: 4
      t.datetime "deleted_at"
      t.datetime "created_at",                         null: false
      t.datetime "updated_at",                         null: false
    end
    
    add_index "adventure_groups", ["adventure_id"], name: "index_adventure_groups_on_adventure_id", using: :btree
    add_index "adventure_groups", ["deleted_at"], name: "index_adventure_groups_on_deleted_at", using: :btree
    add_index "adventure_groups", ["group_id"], name: "index_adventure_groups_on_group_id", using: :btree
    
    create_table "adventure_translations", force: :cascade do |t|
      t.integer  "adventure_id", limit: 4,     null: false
      t.string   "locale",       limit: 255,   null: false
      t.datetime "created_at",                 null: false
      t.datetime "updated_at",                 null: false
      t.string   "title",        limit: 255
      t.text     "content",      limit: 65535
    end
    
    add_index "adventure_translations", ["adventure_id"], name: "index_adventure_translations_on_adventure_id", using: :btree
    add_index "adventure_translations", ["locale"], name: "index_adventure_translations_on_locale", using: :btree
    
    create_table "adventures", force: :cascade do |t|
      t.string   "title",           limit: 255
      t.text     "content",         limit: 65535
      t.integer  "max_points",      limit: 4,                     null: false
      t.integer  "introduction_id", limit: 4
      t.boolean  "publish_results",               default: false, null: false
      t.datetime "start_date"
      t.datetime "end_date"
      t.datetime "deleted_at"
      t.datetime "created_at",                                    null: false
      t.datetime "updated_at",                                    null: false
      t.string   "video",           limit: 255
    end
    
    add_index "adventures", ["deleted_at"], name: "index_adventures_on_deleted_at", using: :btree
    add_index "adventures", ["end_date"], name: "index_adventures_on_end_date", using: :btree
    add_index "adventures", ["introduction_id"], name: "index_adventures_on_introduction_id", using: :btree
    add_index "adventures", ["start_date"], name: "index_adventures_on_start_date", using: :btree
    
    create_table "album_translations", force: :cascade do |t|
      t.integer  "album_id",    limit: 4,     null: false
      t.string   "locale",      limit: 255,   null: false
      t.datetime "created_at",                null: false
      t.datetime "updated_at",                null: false
      t.string   "title",       limit: 255
      t.text     "description", limit: 65535
    end
    
    add_index "album_translations", ["album_id"], name: "index_album_translations_on_album_id", using: :btree
    add_index "album_translations", ["locale"], name: "index_album_translations_on_locale", using: :btree
    
    create_table "albums", force: :cascade do |t|
      t.string   "title",        limit: 255
      t.text     "description",  limit: 65535
      t.string   "location",     limit: 255
      t.datetime "start_date"
      t.datetime "end_date"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "category",     limit: 255
      t.integer  "images_count", limit: 4,     default: 0, null: false
    end
    
    create_table "blog_post_translations", force: :cascade do |t|
      t.integer  "blog_post_id", limit: 4,     null: false
      t.string   "locale",       limit: 255,   null: false
      t.datetime "created_at",                 null: false
      t.datetime "updated_at",                 null: false
      t.string   "title",        limit: 255
      t.text     "preamble",     limit: 65535
      t.text     "content",      limit: 65535
    end
    
    add_index "blog_post_translations", ["blog_post_id"], name: "index_blog_post_translations_on_blog_post_id", using: :btree
    add_index "blog_post_translations", ["locale"], name: "index_blog_post_translations_on_locale", using: :btree
    
    create_table "blog_posts", force: :cascade do |t|
      t.integer  "user_id",     limit: 4
      t.string   "title",       limit: 255
      t.text     "preamble",    limit: 65535
      t.text     "content",     limit: 65535
      t.datetime "deleted_at"
      t.string   "cover_image", limit: 255
      t.datetime "created_at",                null: false
      t.datetime "updated_at",                null: false
    end
    
    add_index "blog_posts", ["deleted_at"], name: "index_blog_posts_on_deleted_at", using: :btree
    add_index "blog_posts", ["user_id"], name: "index_blog_posts_on_user_id", using: :btree
    
    create_table "cafe_shifts", force: :cascade do |t|
      t.datetime "start",           null: false
      t.integer  "pass",  limit: 4, null: false
      t.integer  "lp",    limit: 4, null: false
      t.integer  "lv",    limit: 4, null: false
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
    
    create_table "categories", force: :cascade do |t|
      t.string   "title",      limit: 255, null: false
      t.string   "slug",       limit: 255, null: false
      t.datetime "created_at",             null: false
      t.datetime "updated_at",             null: false
    end
    
    add_index "categories", ["slug"], name: "index_categories_on_slug", using: :btree
    
    create_table "categorizations", force: :cascade do |t|
      t.integer  "category_id",        limit: 4
      t.string   "categorizable_type", limit: 255, null: false
      t.integer  "categorizable_id",   limit: 4,   null: false
      t.datetime "created_at",                     null: false
      t.datetime "updated_at",                     null: false
    end
    
    add_index "categorizations", ["categorizable_id"], name: "index_categorizations_on_categorizable_id", using: :btree
    add_index "categorizations", ["categorizable_type"], name: "index_categorizations_on_categorizable_type", using: :btree
    add_index "categorizations", ["category_id"], name: "index_categorizations_on_category_id", using: :btree
    
    create_table "constants", force: :cascade do |t|
      t.string   "name",       limit: 255
      t.string   "value",      limit: 255
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "contact_translations", force: :cascade do |t|
      t.integer  "contact_id", limit: 4,     null: false
      t.string   "locale",     limit: 255,   null: false
      t.datetime "created_at",               null: false
      t.datetime "updated_at",               null: false
      t.string   "name",       limit: 255
      t.text     "text",       limit: 65535
    end
    
    add_index "contact_translations", ["contact_id"], name: "index_contact_translations_on_contact_id", using: :btree
    add_index "contact_translations", ["locale"], name: "index_contact_translations_on_locale", using: :btree
    
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
      t.string   "title",        limit: 255
      t.string   "url",          limit: 255
      t.text     "description",  limit: 65535
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "president_id", limit: 4
    end
    
    add_index "councils", ["president_id"], name: "index_councils_on_president_id", using: :btree
    add_index "councils", ["url"], name: "index_councils_on_url", using: :btree
    
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
      t.string   "slug",             limit: 255
    end
    
    create_table "doors", force: :cascade do |t|
      t.string   "title",       limit: 255
      t.string   "slug",        limit: 255
      t.text     "description", limit: 65535
      t.datetime "created_at",                null: false
      t.datetime "updated_at",                null: false
    end
    
    create_table "election_posts", force: :cascade do |t|
      t.integer  "election_id", limit: 4
      t.integer  "post_id",     limit: 4
      t.datetime "created_at",            null: false
      t.datetime "updated_at",            null: false
    end
    
    add_index "election_posts", ["election_id"], name: "index_election_posts_on_election_id", using: :btree
    add_index "election_posts", ["post_id"], name: "index_election_posts_on_post_id", using: :btree
    
    create_table "elections", force: :cascade do |t|
      t.datetime "open"
      t.datetime "close_general"
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
      t.datetime "close_all"
      t.string   "semester",            limit: 255,   default: "spring"
    end
    
    create_table "event_registrations", force: :cascade do |t|
      t.integer  "user_id",    limit: 4
      t.integer  "event_id",   limit: 4
      t.boolean  "reserve",                  default: false
      t.datetime "created_at",                               null: false
      t.datetime "updated_at",                               null: false
      t.text     "answer",     limit: 65535
    end
    
    create_table "event_signup_translations", force: :cascade do |t|
      t.integer  "event_signup_id", limit: 4,   null: false
      t.string   "locale",          limit: 255, null: false
      t.datetime "created_at",                  null: false
      t.datetime "updated_at",                  null: false
      t.string   "question",        limit: 255
    end
    
    add_index "event_signup_translations", ["event_signup_id"], name: "index_event_signup_translations_on_event_signup_id", using: :btree
    add_index "event_signup_translations", ["locale"], name: "index_event_signup_translations_on_locale", using: :btree
    
    create_table "event_signups", force: :cascade do |t|
      t.integer  "event_id",    limit: 4
      t.boolean  "for_members",             default: true, null: false
      t.string   "question",    limit: 255
      t.integer  "slots",       limit: 4,                  null: false
      t.datetime "closes",                                 null: false
      t.datetime "opens",                                  null: false
      t.integer  "novice",      limit: 4
      t.integer  "mentor",      limit: 4
      t.integer  "member",      limit: 4
      t.integer  "custom",      limit: 4
      t.string   "custom_name", limit: 255
      t.datetime "deleted_at"
      t.datetime "created_at",                             null: false
      t.datetime "updated_at",                             null: false
    end
    
    add_index "event_signups", ["deleted_at"], name: "index_event_signups_on_deleted_at", using: :btree
    add_index "event_signups", ["event_id"], name: "event_signups_unique_event_index", unique: true, using: :btree
    add_index "event_signups", ["event_id"], name: "index_event_signups_on_event_id", using: :btree
    
    create_table "event_translations", force: :cascade do |t|
      t.integer  "event_id",    limit: 4,     null: false
      t.string   "locale",      limit: 255,   null: false
      t.datetime "created_at",                null: false
      t.datetime "updated_at",                null: false
      t.string   "title",       limit: 255
      t.text     "description", limit: 65535
      t.string   "short",       limit: 255
      t.string   "location",    limit: 255
    end
    
    add_index "event_translations", ["event_id"], name: "index_event_translations_on_event_id", using: :btree
    add_index "event_translations", ["locale"], name: "index_event_translations_on_locale", using: :btree
    
    create_table "event_users", force: :cascade do |t|
      t.integer  "user_id",    limit: 4
      t.integer  "event_id",   limit: 4
      t.integer  "group_id",   limit: 4
      t.text     "answer",     limit: 65535
      t.string   "user_type",  limit: 255
      t.datetime "deleted_at"
      t.datetime "created_at",               null: false
      t.datetime "updated_at",               null: false
    end
    
    add_index "event_users", ["deleted_at"], name: "index_event_users_on_deleted_at", using: :btree
    add_index "event_users", ["event_id"], name: "index_event_users_on_event_id", using: :btree
    add_index "event_users", ["group_id"], name: "index_event_users_on_group_id", using: :btree
    add_index "event_users", ["user_id"], name: "index_event_users_on_user_id", using: :btree
    
    create_table "events", force: :cascade do |t|
      t.string   "title",           limit: 255
      t.text     "description",     limit: 65535
      t.string   "location",        limit: 255
      t.datetime "starts_at"
      t.datetime "ends_at"
      t.boolean  "all_day"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "image_file_name", limit: 255
      t.integer  "council_id",      limit: 4
      t.string   "short",           limit: 255
      t.string   "dot",             limit: 255
      t.boolean  "drink"
      t.boolean  "food"
      t.boolean  "cash"
      t.datetime "deleted_at"
      t.integer  "price",           limit: 4
      t.string   "dress_code",      limit: 255
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
    
    create_table "group_messages", force: :cascade do |t|
      t.integer  "group_id",   limit: 4
      t.integer  "message_id", limit: 4
      t.datetime "deleted_at"
      t.datetime "created_at",           null: false
      t.datetime "updated_at",           null: false
    end
    
    add_index "group_messages", ["deleted_at"], name: "index_group_messages_on_deleted_at", using: :btree
    add_index "group_messages", ["group_id"], name: "index_group_messages_on_group_id", using: :btree
    add_index "group_messages", ["message_id"], name: "index_group_messages_on_message_id", using: :btree
    
    create_table "group_users", force: :cascade do |t|
      t.integer  "group_id",   limit: 4
      t.integer  "user_id",    limit: 4
      t.boolean  "fadder",               default: false, null: false
      t.datetime "deleted_at"
      t.datetime "created_at",                           null: false
      t.datetime "updated_at",                           null: false
    end
    
    add_index "group_users", ["deleted_at"], name: "index_group_users_on_deleted_at", using: :btree
    add_index "group_users", ["group_id"], name: "index_group_users_on_group_id", using: :btree
    add_index "group_users", ["user_id"], name: "index_group_users_on_user_id", using: :btree
    
    create_table "groups", force: :cascade do |t|
      t.string   "name",            limit: 255
      t.integer  "number",          limit: 4
      t.integer  "introduction_id", limit: 4
      t.datetime "deleted_at"
      t.datetime "created_at",                                      null: false
      t.datetime "updated_at",                                      null: false
      t.string   "group_type",      limit: 255, default: "regular", null: false
    end
    
    add_index "groups", ["deleted_at"], name: "index_groups_on_deleted_at", using: :btree
    add_index "groups", ["introduction_id"], name: "index_groups_on_introduction_id", using: :btree
    
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
    
    create_table "introduction_translations", force: :cascade do |t|
      t.integer  "introduction_id", limit: 4,     null: false
      t.string   "locale",          limit: 255,   null: false
      t.datetime "created_at",                    null: false
      t.datetime "updated_at",                    null: false
      t.string   "title",           limit: 255
      t.text     "description",     limit: 65535
    end
    
    add_index "introduction_translations", ["introduction_id"], name: "index_introduction_translations_on_introduction_id", using: :btree
    add_index "introduction_translations", ["locale"], name: "index_introduction_translations_on_locale", using: :btree
    
    create_table "introductions", force: :cascade do |t|
      t.string   "title",       limit: 255,   default: "",   null: false
      t.datetime "start",                                    null: false
      t.datetime "stop",                                     null: false
      t.string   "slug",        limit: 255,                  null: false
      t.text     "description", limit: 65535
      t.boolean  "current",                   default: true, null: false
      t.datetime "deleted_at"
      t.datetime "created_at",                               null: false
      t.datetime "updated_at",                               null: false
    end
    
    add_index "introductions", ["deleted_at"], name: "index_introductions_on_deleted_at", using: :btree
    add_index "introductions", ["slug"], name: "index_introductions_on_slug", using: :btree
    
    create_table "mail_aliases", force: :cascade do |t|
      t.string   "username",   limit: 255, null: false
      t.string   "domain",     limit: 255, null: false
      t.string   "target",     limit: 255, null: false
      t.datetime "updated_at",             null: false
    end
    
    add_index "mail_aliases", ["target"], name: "index_mail_aliases_on_target", using: :btree
    add_index "mail_aliases", ["username", "domain", "target"], name: "index_mail_aliases_on_username_and_domain_and_target", unique: true, using: :btree
    
    create_table "main_menu_translations", force: :cascade do |t|
      t.integer  "main_menu_id", limit: 4,   null: false
      t.string   "locale",       limit: 255, null: false
      t.datetime "created_at",               null: false
      t.datetime "updated_at",               null: false
      t.string   "name",         limit: 255
    end
    
    add_index "main_menu_translations", ["locale"], name: "index_main_menu_translations_on_locale", using: :btree
    add_index "main_menu_translations", ["main_menu_id"], name: "index_main_menu_translations_on_main_menu_id", using: :btree
    
    create_table "main_menus", force: :cascade do |t|
      t.string   "name",       limit: 255
      t.integer  "index",      limit: 4
      t.boolean  "mega",                   default: true,  null: false
      t.boolean  "fw",                     default: false, null: false
      t.datetime "created_at",                             null: false
      t.datetime "updated_at",                             null: false
    end
    
    create_table "menu_translations", force: :cascade do |t|
      t.integer  "menu_id",    limit: 4,   null: false
      t.string   "locale",     limit: 255, null: false
      t.datetime "created_at",             null: false
      t.datetime "updated_at",             null: false
      t.string   "name",       limit: 255
    end
    
    add_index "menu_translations", ["locale"], name: "index_menu_translations_on_locale", using: :btree
    add_index "menu_translations", ["menu_id"], name: "index_menu_translations_on_menu_id", using: :btree
    
    create_table "menus", force: :cascade do |t|
      t.integer  "index",        limit: 4
      t.string   "link",         limit: 255
      t.string   "name",         limit: 255
      t.boolean  "visible",                  default: true
      t.boolean  "turbolinks",               default: true
      t.boolean  "blank_p"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "header",                   default: false, null: false
      t.integer  "column",       limit: 4,   default: 1,     null: false
      t.integer  "main_menu_id", limit: 4
    end
    
    add_index "menus", ["main_menu_id"], name: "index_menus_on_main_menu_id", using: :btree
    
    create_table "message_comments", force: :cascade do |t|
      t.integer  "message_id", limit: 4
      t.integer  "user_id",    limit: 4
      t.text     "content",    limit: 65535,                 null: false
      t.datetime "deleted_at"
      t.datetime "created_at",                               null: false
      t.datetime "updated_at",                               null: false
      t.boolean  "by_admin",                 default: false, null: false
    end
    
    add_index "message_comments", ["deleted_at"], name: "index_message_comments_on_deleted_at", using: :btree
    add_index "message_comments", ["message_id"], name: "index_message_comments_on_message_id", using: :btree
    add_index "message_comments", ["user_id"], name: "index_message_comments_on_user_id", using: :btree
    
    create_table "messages", force: :cascade do |t|
      t.integer  "user_id",                limit: 4
      t.text     "content",                limit: 65535,                 null: false
      t.datetime "deleted_at"
      t.integer  "message_comments_count", limit: 4,     default: 0,     null: false
      t.datetime "created_at",                                           null: false
      t.datetime "updated_at",                                           null: false
      t.boolean  "by_admin",                             default: false, null: false
      t.integer  "introduction_id",        limit: 4
    end
    
    add_index "messages", ["deleted_at"], name: "index_messages_on_deleted_at", using: :btree
    add_index "messages", ["introduction_id"], name: "index_messages_on_introduction_id", using: :btree
    add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree
    
    create_table "news", force: :cascade do |t|
      t.string   "title",      limit: 255
      t.text     "content",    limit: 65535
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "user_id",    limit: 4
      t.string   "url",        limit: 255
      t.string   "image",      limit: 255
    end
    
    create_table "news_translations", force: :cascade do |t|
      t.integer  "news_id",    limit: 4,     null: false
      t.string   "locale",     limit: 255,   null: false
      t.datetime "created_at",               null: false
      t.datetime "updated_at",               null: false
      t.string   "title",      limit: 255
      t.text     "content",    limit: 65535
    end
    
    add_index "news_translations", ["locale"], name: "index_news_translations_on_locale", using: :btree
    add_index "news_translations", ["news_id"], name: "index_news_translations_on_news_id", using: :btree
    
    create_table "nominations", force: :cascade do |t|
      t.integer  "post_id",     limit: 4
      t.integer  "election_id", limit: 4
      t.string   "name",        limit: 255
      t.string   "email",       limit: 255
      t.text     "motivation",  limit: 65535
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "notice_translations", force: :cascade do |t|
      t.integer  "notice_id",   limit: 4,     null: false
      t.string   "locale",      limit: 255,   null: false
      t.datetime "created_at",                null: false
      t.datetime "updated_at",                null: false
      t.string   "title",       limit: 255
      t.text     "description", limit: 65535
    end
    
    add_index "notice_translations", ["locale"], name: "index_notice_translations_on_locale", using: :btree
    add_index "notice_translations", ["notice_id"], name: "index_notice_translations_on_notice_id", using: :btree
    
    create_table "notices", force: :cascade do |t|
      t.string   "title",       limit: 255
      t.text     "description", limit: 65535
      t.boolean  "public"
      t.datetime "d_publish"
      t.datetime "d_remove"
      t.integer  "sort",        limit: 4
      t.string   "image",       limit: 255
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "user_id",     limit: 4,     null: false
    end
    
    create_table "page_element_translations", force: :cascade do |t|
      t.integer  "page_element_id", limit: 4,     null: false
      t.string   "locale",          limit: 255,   null: false
      t.datetime "created_at",                    null: false
      t.datetime "updated_at",                    null: false
      t.text     "text",            limit: 65535
      t.string   "headline",        limit: 255
    end
    
    add_index "page_element_translations", ["locale"], name: "index_page_element_translations_on_locale", using: :btree
    add_index "page_element_translations", ["page_element_id"], name: "index_page_element_translations_on_page_element_id", using: :btree
    
    create_table "page_elements", force: :cascade do |t|
      t.integer  "index",         limit: 4,     default: 1
      t.boolean  "sidebar"
      t.boolean  "visible",                     default: true
      t.text     "text",          limit: 65535
      t.string   "headline",      limit: 255
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
    
    create_table "page_translations", force: :cascade do |t|
      t.integer  "page_id",    limit: 4,                null: false
      t.string   "locale",     limit: 255,              null: false
      t.datetime "created_at",                          null: false
      t.datetime "updated_at",                          null: false
      t.string   "title",      limit: 255, default: ""
    end
    
    add_index "page_translations", ["locale"], name: "index_page_translations_on_locale", using: :btree
    add_index "page_translations", ["page_id"], name: "index_page_translations_on_page_id", using: :btree
    
    create_table "pages", force: :cascade do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "council_id", limit: 4
      t.string   "url",        limit: 255
      t.boolean  "visible"
      t.string   "title",      limit: 255
      t.boolean  "public",                 default: true, null: false
      t.string   "namespace",  limit: 255
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
      t.text     "purpose",    limit: 65535
      t.boolean  "aktiv",                    default: true
      t.integer  "council_id", limit: 4
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "comment",    limit: 65535
      t.string   "status",     limit: 255,   default: "unconfirmed"
      t.boolean  "service",                  default: false
      t.integer  "user_id",    limit: 4
    end
    
    add_index "rents", ["council_id"], name: "index_rents_on_council_id", using: :btree
    add_index "rents", ["user_id"], name: "index_rents_on_user_id", using: :btree
    
    create_table "short_links", force: :cascade do |t|
      t.string "link",   limit: 255,   null: false
      t.text   "target", limit: 65535, null: false
    end
    
    add_index "short_links", ["link"], name: "index_short_links_on_link", using: :btree
    
    create_table "tool_rentings", force: :cascade do |t|
      t.string   "renter",      limit: 255,                 null: false
      t.string   "purpose",     limit: 255
      t.integer  "tool_id",     limit: 4,                   null: false
      t.date     "return_date",                             null: false
      t.boolean  "returned",                default: false
      t.datetime "created_at",                              null: false
      t.datetime "updated_at",                              null: false
    end
    
    add_index "tool_rentings", ["renter"], name: "index_tool_rentings_on_renter", using: :btree
    add_index "tool_rentings", ["tool_id"], name: "index_tool_rentings_on_tool_id", using: :btree
    
    create_table "tools", force: :cascade do |t|
      t.string   "title",       limit: 255,               null: false
      t.text     "description", limit: 65535,             null: false
      t.integer  "total",       limit: 4,     default: 1
      t.datetime "created_at",                            null: false
      t.datetime "updated_at",                            null: false
    end
    
    create_table "users", force: :cascade do |t|
      t.string   "email",                  limit: 255, default: "",    null: false
      t.string   "encrypted_password",     limit: 255, default: "",    null: false
      t.string   "reset_password_token",   limit: 255
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip",     limit: 255
      t.string   "last_sign_in_ip",        limit: 255
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "firstname",              limit: 255
      t.string   "lastname",               limit: 255
      t.string   "phone",                  limit: 255
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
      t.string   "food_preference",        limit: 255
      t.string   "student_id",             limit: 255
      t.boolean  "display_phone",                      default: false, null: false
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
    add_foreign_key "group_messages", "groups"
    add_foreign_key "group_messages", "messages"
    add_foreign_key "group_users", "groups"
    add_foreign_key "group_users", "users"
    add_foreign_key "groups", "introductions"
    add_foreign_key "menus", "main_menus"
    add_foreign_key "message_comments", "messages"
    add_foreign_key "message_comments", "users"
    add_foreign_key "messages", "introductions"
    add_foreign_key "messages", "users"
    add_foreign_key "page_images", "pages"
    add_foreign_key "rents", "users"
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "The initial migration is not revertable"
  end
end
