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

ActiveRecord::Schema.define(version: 20140826024707) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ingredients", force: :cascade do |t|
    t.integer  "recipe_id",               null: false
    t.integer  "index",                   null: false
    t.string   "quantity",    limit: 255
    t.string   "measurement", limit: 255
    t.string   "description", limit: 255, null: false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ingredients", ["recipe_id", "index"], name: "index_ingredients_on_recipe_id_and_index", unique: true, using: :btree

  create_table "list_items", force: :cascade do |t|
    t.integer  "list_id",                                    null: false
    t.decimal  "quantity",                                   null: false
    t.string   "measurement",    limit: 255
    t.string   "description",    limit: 255,                 null: false
    t.boolean  "purchased",                  default: false
    t.boolean  "manually_added",             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lists", force: :cascade do |t|
    t.integer  "plan_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meals", force: :cascade do |t|
    t.integer  "plan_id",    null: false
    t.integer  "recipe_id",  null: false
    t.integer  "day",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plans", force: :cascade do |t|
    t.integer  "month",      null: false
    t.integer  "year",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plans", ["month", "year"], name: "index_plans_on_month_and_year", unique: true, using: :btree

  create_table "recipes", force: :cascade do |t|
    t.string   "title",      limit: 255, null: false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "steps", force: :cascade do |t|
    t.integer  "recipe_id",   null: false
    t.integer  "index",       null: false
    t.text     "description", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "steps", ["recipe_id", "index"], name: "index_steps_on_recipe_id_and_index", unique: true, using: :btree

end
