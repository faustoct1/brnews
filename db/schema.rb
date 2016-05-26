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

ActiveRecord::Schema.define(version: 20) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "accounts", force: :cascade do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", force: :cascade do |t|
    t.string   "email"
    t.boolean  "subscribed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
  end

  create_table "post_digests", force: :cascade do |t|
    t.string   "title"
    t.string   "topic_name"
    t.string   "period"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "published"
    t.string   "source"
    t.string   "url"
    t.string   "qtitle"
    t.string   "fb_full_pic"
  end

  create_table "settings", force: :cascade do |t|
    t.boolean  "pt"
    t.boolean  "us"
    t.boolean  "website"
    t.boolean  "youtube"
    t.boolean  "wikipedia"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["user_id"], name: "index_settings_on_user_id", using: :btree

  create_table "source_misses", force: :cascade do |t|
    t.text     "uid"
    t.text     "url"
    t.text     "source_type"
    t.text     "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "source_topics", force: :cascade do |t|
    t.integer  "source_id"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "source_topics", ["source_id"], name: "index_source_topics_on_source_id", using: :btree
  add_index "source_topics", ["topic_id"], name: "index_source_topics_on_topic_id", using: :btree

  create_table "sources", force: :cascade do |t|
    t.text     "name"
    t.text     "website"
    t.text     "fb_page"
    t.text     "fb_id"
    t.text     "language"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stories", force: :cascade do |t|
    t.text     "uid_url"
    t.text     "source_type"
    t.text     "description"
    t.text     "title"
    t.integer  "published"
    t.text     "fb_story"
    t.text     "fb_pic"
    t.text     "fb_icon"
    t.text     "fb_type"
    t.text     "fb_from_category"
    t.text     "fb_from_name"
    t.text     "fb_from_id"
    t.text     "fb_status_type"
    t.text     "fb_message"
    t.text     "fb_link"
    t.text     "fb_caption"
    t.text     "ytb_thumbnail"
    t.text     "ytb_channelId"
    t.text     "ytb_videoId"
    t.text     "ytb_channel_name"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "qtitle"
    t.string   "fb_full_pic"
  end

  add_index "stories", ["qtitle"], name: "index_stories_on_qtitle", using: :btree
  add_index "stories", ["uid_url", "source_type"], name: "index_stories_on_uid_url_and_source_type", using: :btree

  create_table "summary_push_notifications", force: :cascade do |t|
    t.boolean  "notify"
    t.string   "registration_id"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", force: :cascade do |t|
    t.text     "name"
    t.text     "us"
    t.text     "pt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_topics", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_topics", ["topic_id"], name: "index_user_topics_on_topic_id", using: :btree
  add_index "user_topics", ["user_id"], name: "index_user_topics_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.text     "facebook_uid"
    t.text     "facebook_name"
    t.text     "facebook_email"
    t.text     "facebook_image"
    t.text     "facebook_token"
    t.boolean  "facebook_verified"
    t.text     "google_oauth2_uid"
    t.text     "google_oauth2_name"
    t.text     "google_oauth2_email"
    t.text     "google_oauth2_image"
    t.text     "google_oauth2_token"
    t.boolean  "google_oauth2_verified"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
