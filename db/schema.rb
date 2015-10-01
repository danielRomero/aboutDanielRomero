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

ActiveRecord::Schema.define(version: 20151001155831) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "tweets", force: :cascade do |t|
    t.integer  "retweet_count",      default: 0
    t.integer  "favorite_count",     default: 0
    t.datetime "tweet_created_at"
    t.string   "url"
    t.text     "full_text",          default: ""
    t.integer  "twitter_account_id"
    t.string   "twitter_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "tweets", ["twitter_account_id"], name: "index_tweets_on_twitter_account_id", using: :btree

  create_table "twitter_accounts", force: :cascade do |t|
    t.string   "username",        default: ""
    t.integer  "followers_count", default: 0
    t.integer  "following_count", default: 0
    t.string   "url",             default: ""
    t.string   "avatar_url",      default: ""
    t.integer  "tweets_count",    default: 0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

end
