# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_30_203814) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "items", force: :cascade do |t|
    t.integer "uid"
    t.string "unique_name"
    t.string "name"
    t.string "item_type"
    t.string "item_subtype"
    t.integer "npc_price"
    t.integer "slots"
    t.text "icon"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uid"], name: "index_items_on_uid"
  end

  create_table "shop_items", force: :cascade do |t|
    t.integer "shop_id"
    t.integer "item_id"
    t.integer "quantity"
    t.integer "price"
    t.integer "refine"
    t.integer "star_crumbs"
    t.string "element"
    t.integer "forger"
    t.boolean "beloved"
    t.string "state"
    t.integer "original_quantity"
    t.integer "transacted_quantity"
    t.integer "cards", array: true
    t.index ["cards"], name: "index_shop_items_on_cards", using: :gin
    t.index ["item_id"], name: "index_shop_items_on_item_id"
    t.index ["shop_id"], name: "index_shop_items_on_shop_id"
    t.index ["state"], name: "index_shop_items_on_state"
  end

  create_table "shops", force: :cascade do |t|
    t.string "title"
    t.string "username"
    t.string "location_map"
    t.integer "location_x"
    t.integer "location_y"
    t.datetime "start_date"
    t.string "shop_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "state"
    t.index ["state"], name: "index_shops_on_state"
    t.index ["username"], name: "index_shops_on_username"
  end

end
