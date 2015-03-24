class FsekStructure < ActiveRecord::Migration
  def change
    unless table_exists? :album_categories
      create_table "album_categories" do |t|
        t.string   "name"
        t.text     "text"
        t.boolean  "visible"
        t.datetime "created_at"
        t.datetime "updated_at"
      end
    end
    unless table_exists? :album_categories_albums
      create_table "album_categories_albums", id: false do |t|
        t.integer "album_id"
        t.integer "album_category_id"
      end
    end
    unless table_exists? :albums
      create_table "albums" do |t|
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
    end
    unless table_exists? :albums_images    
      create_table "albums_images", id: false do |t|
        t.integer "album_id"
        t.integer "image_id"
      end
    end
    unless table_exists? :albums_subcategories
      create_table "albums_subcategories", id: false do |t|
        t.integer "album_id"
        t.integer "subcategory_id"
      end
    end
    unless table_exists? :candidates
      create_table "candidates" do |t|
        t.integer  "post_id"
        t.integer  "profile_id"
        t.integer  "election_id"
        t.text     "motivation"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.string   "stil_id"
        t.string   "email"
        t.string   "phone"
      end
    end
    unless table_exists? :contacts
      create_table "contacts" do |t|
        t.string   "name"
        t.string   "email"
        t.boolean  "public"
        t.text     "text"
        t.integer  "council_id"
        t.datetime "created_at"
        t.datetime "updated_at"
      end
    end
    unless table_exists? :councils
      create_table "councils" do |t|
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
    end
    unless table_exists? :documents
      create_table "documents" do |t|
        t.string   "pdf_file_name"
        t.string   "pdf_content_type"
        t.integer  "pdf_file_size"
        t.datetime "pdf_updated_at"
        t.string   "title"
        t.boolean  "public"
        t.boolean  "download"
        t.string   "category"
        t.integer  "profile_id"
        t.datetime "created_at"
        t.datetime "updated_at"
      end
    end
    unless table_exists? :elections
      create_table "elections" do |t|
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
    end
    unless table_exists? :elections_posts
      create_table "elections_posts", id: false do |t|
        t.integer "election_id"
        t.integer "post_id"
      end
    end
    unless table_exists? :events
      create_table "events" do |t|
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
    end
    unless table_exists? :faqs
      create_table "faqs" do |t|
        t.string   "question"
        t.text     "answer"
        t.integer  "sorting_index"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.string   "category", index: true
      end
    end
    unless table_exists? :images
      create_table "images" do |t|
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
    end
    unless table_exists? :lists
      create_table "lists" do |t|
        t.string   "category"
        t.string   "name"
        t.string   "string1"
        t.integer  "int1"
        t.boolean  "bool1"
        t.datetime "created_at"
        t.datetime "updated_at"
      end
    end
    unless table_exists? :menus
      create_table :menus do |t|
        t.string "location"
        t.integer "index"
        t.string "link"
        t.string "name"
        t.boolean "visible"
        t.boolean "turbolinks", default: true
        t.boolean "blank_p"
        t.timestamps
      end
    end
    unless table_exists? :news
      create_table "news" do |t|
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
    end
    unless table_exists? :nominations
      create_table "nominations" do |t|
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
    end
    unless table_exists? :page_elements
      create_table "page_elements" do |t|
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
    end
    unless table_exists? :pages
      create_table "pages" do |t|
        t.datetime "created_at"
        t.datetime "updated_at"
        t.integer  "council_id"
      end
    end
    unless table_exists? :photo_categories
      create_table "photo_categories" do |t|
        t.string   "name"
        t.string   "text"
        t.boolean  "visible"
        t.datetime "created_at"
        t.datetime "updated_at"
      end
    end
    unless table_exists? :posts
      create_table "posts" do |t|
        t.string   "title"
        t.integer  "limit"
        t.text     "description"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.integer  "council_id"
        t.boolean  "extra_text"
        t.string   "elected_by"
        t.string   "elected_at"
        t.text     "election_text"
        t.boolean  "styrelse"
        t.integer  "limit", default: 0
        t.integer  "recLimit", default: 0
        t.boolean  "car_rent"
      end
    end
    unless table_exists? :posts_profiles
      create_table "posts_profiles", id: false do |t|
        t.integer "post_id"
        t.integer "profile_id"
      end
    end
    unless table_exists? :profiles
      create_table "profiles" do |t|
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
    end
    unless table_exists? :rents
      create_table :rents do |t|
        t.datetime "d_from"
        t.datetime "d_til"
        t.string   "name"
        t.string   "lastname"
        t.string   "email"
        t.string   "phone"
        t.text     "purpose"
        t.boolean  "disclaimer"
        t.string   "status", default: "Ej bestämd"
        t.boolean  "aktiv", default: true
        t.integer  "council_id"
        t.integer  "profile_id"
        t.text     "comment"
        t.boolean  "service"
        t.timestamps
      end
    end
    unless table_exists? :roles
      create_table "roles" do |t|
        t.string   "name",        null: false
        t.string   "title",       null: false
        t.text     "description", null: false
        t.text     "the_role",    null: false
        t.datetime "created_at"
        t.datetime "updated_at"
      end
    end
    unless table_exists? :subcategories
      create_table "subcategories" do |t|
        t.string   "text"
        t.datetime "created_at"
        t.datetime "updated_at"
      end
    end
    unless table_exists? :users
      create_table "users" do |t|
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
    end
    unless table_exists? :users
      add_index "users", ["email"], name: "index_users_on_email", unique: true
      add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    end
    unless table_exists? :work_posts
      create_table "work_posts" do |t|
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
  end
end
