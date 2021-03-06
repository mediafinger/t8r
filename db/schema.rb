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

ActiveRecord::Schema.define(version: 20140307063008) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "apps", force: true do |t|
    t.text     "name"
    t.text     "key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apps", ["key"], name: "index_apps_on_key", unique: true, using: :btree

  create_table "locales", force: true do |t|
    t.integer  "app_id"
    t.text     "name"
    t.text     "key"
    t.boolean  "hidden",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locales", ["hidden"], name: "index_locales_on_hidden", using: :btree
  add_index "locales", ["key"], name: "index_locales_on_key", using: :btree

  create_table "phrases", force: true do |t|
    t.integer  "app_id"
    t.text     "key"
    t.text     "value"
    t.text     "hint"
    t.boolean  "done",       default: false
    t.boolean  "hidden",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phrases", ["done"], name: "index_phrases_on_done", using: :btree
  add_index "phrases", ["hidden"], name: "index_phrases_on_hidden", using: :btree
  add_index "phrases", ["key"], name: "index_phrases_on_key", using: :btree

  create_table "translations", force: true do |t|
    t.integer  "app_id"
    t.integer  "locale_id"
    t.integer  "phrase_id"
    t.text     "value"
    t.boolean  "done",       default: false
    t.boolean  "hidden",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "translations", ["done"], name: "index_translations_on_done", using: :btree
  add_index "translations", ["hidden"], name: "index_translations_on_hidden", using: :btree

end
