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

ActiveRecord::Schema.define(version: 2014_12_06_170621) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "businesses", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "funnel_stage"
    t.datetime "created_at"
  end

  create_table "order_items", id: :serial, force: :cascade do |t|
    t.integer "order_id"
    t.integer "product_id"
    t.float "unit_price"
    t.integer "quantity"
    t.float "subtotal"
  end

  create_table "orders", id: :serial, force: :cascade do |t|
    t.integer "business_id"
    t.integer "user_id"
    t.float "total"
  end

  create_table "products", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "picture_file_name"
    t.string "picture_content_type"
    t.bigint "picture_file_size"
    t.datetime "picture_updated_at"
    t.text "description"
    t.float "price"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.integer "business_id"
    t.string "first_name"
    t.string "last_name"
    t.string "position"
    t.datetime "created_at"
  end

end
