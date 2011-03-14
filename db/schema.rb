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

ActiveRecord::Schema.define(:version => 20110313095823) do

  create_table "apache_accesses", :force => true do |t|
    t.string   "remote"
    t.string   "host"
    t.string   "user"
    t.string   "http_method"
    t.string   "http_url"
    t.string   "http_version"
    t.integer  "result"
    t.integer  "bytes"
    t.string   "referer"
    t.string   "user_agent"
    t.string   "unknown"
    t.string   "local"
    t.integer  "timestamp"
    t.integer  "pid"
    t.integer  "counter"
    t.integer  "thread_index"
    t.integer  "processing_time"
    t.datetime "observed_at"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "archive_contents", :force => true do |t|
    t.string   "type"
    t.string   "archive"
    t.string   "name"
    t.integer  "size"
    t.boolean  "directory"
    t.datetime "observed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "artefacts", :force => true do |t|
    t.integer  "entry_id"
    t.string   "path"
    t.string   "revision"
    t.integer  "size"
    t.datetime "submitted_at"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "auths", :force => true do |t|
    t.datetime "observed_at"
    t.string   "host"
    t.string   "process"
    t.integer  "pid"
    t.text     "message"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entries", :force => true do |t|
    t.string   "name"
    t.integer  "repository_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matches", :force => true do |t|
    t.integer  "archive_content_id"
    t.integer  "apache_access_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "repositories", :force => true do |t|
    t.string   "url"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

end
