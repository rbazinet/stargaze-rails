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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130425103002) do

  create_table "astro_constellation", :force => true do |t|
    t.string "name",     :null => false
    t.string "abb1"
    t.string "abb2"
    t.string "genitive"
    t.string "origin"
    t.string "meaning"
  end

  create_table "astro_messier", :force => true do |t|
    t.integer "messier_number",     :null => false
    t.integer "ngc_number"
    t.string  "common_name"
    t.string  "object_type"
    t.float   "distance_kly"
    t.integer "constellation_id",   :null => false
    t.float   "apparent_magnitude"
  end

  create_table "astro_ngc", :force => true do |t|
    t.integer "ngc_number",         :null => false
    t.string  "names"
    t.string  "object_type"
    t.integer "constellation_id",   :null => false
    t.string  "right_ascension"
    t.string  "declination"
    t.float   "apparent_magnitude"
  end

  create_table "astro_solar", :force => true do |t|
    t.string  "name",           :null => false
    t.integer "position"
    t.integer "size"
    t.float   "size_earth"
    t.integer "mass"
    t.float   "mass_earth"
    t.integer "distance"
    t.float   "distance_earth"
    t.float   "orbital_period"
    t.string  "trading_period"
    t.integer "moons"
    t.string  "solar_type"
    t.text    "info"
  end

  create_table "astro_star", :force => true do |t|
    t.string  "name"
    t.integer "constellation_id",   :null => false
    t.string  "right_ascension"
    t.string  "declination"
    t.float   "apparent_magnitude"
    t.string  "stellar_class"
    t.text    "info"
  end

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "user_observation", :force => true do |t|
    t.integer  "user_id",          :null => false
    t.string   "name",             :null => false
    t.text     "description"
    t.text     "eq_used"
    t.text     "conditions"
    t.date     "observation_date"
    t.integer  "observable_id"
    t.string   "observable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "user_photo", :force => true do |t|
    t.integer  "user_id",              :null => false
    t.integer  "observation_id",       :null => false
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "payload_file_name"
    t.string   "payload_content_type"
    t.integer  "payload_file_size"
    t.datetime "payload_updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
