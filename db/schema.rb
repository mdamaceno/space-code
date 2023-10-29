# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_10_29_145536) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contracts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "description", null: false
    t.uuid "origin_planet_id", null: false
    t.uuid "destination_planet_id", null: false
    t.uuid "ship_id"
    t.datetime "completed_at"
    t.integer "value", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pilots", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "certification", limit: 7, null: false
    t.string "name", null: false
    t.integer "age", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "planet_id"
    t.index ["certification"], name: "index_pilots_on_certification", unique: true
  end

  create_table "planets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_planets_on_name", unique: true
  end

  create_table "resources", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.integer "weight", default: 0, null: false
    t.uuid "contract_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "routes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "origin_planet_id", null: false
    t.uuid "destination_planet_id", null: false
    t.boolean "blocked", default: false, null: false
    t.integer "fuel_cost", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["destination_planet_id"], name: "index_routes_on_destination_planet_id"
    t.index ["origin_planet_id", "destination_planet_id"], name: "index_routes_on_origin_planet_id_and_destination_planet_id", unique: true
    t.index ["origin_planet_id"], name: "index_routes_on_origin_planet_id"
  end

  create_table "ships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.integer "fuel_capacity", default: 0, null: false
    t.integer "fuel_level", default: 0, null: false
    t.integer "weight_capacity", default: 0, null: false
    t.uuid "pilot_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "certification", null: false
    t.string "kind", null: false
    t.integer "amount", default: 0, null: false
    t.string "description", default: "", null: false
    t.uuid "contract_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "contracts", "planets", column: "destination_planet_id", on_delete: :cascade
  add_foreign_key "contracts", "planets", column: "origin_planet_id", on_delete: :cascade
  add_foreign_key "contracts", "ships", on_delete: :nullify
  add_foreign_key "pilots", "planets", on_delete: :nullify
  add_foreign_key "resources", "contracts", on_delete: :cascade
  add_foreign_key "routes", "planets", column: "destination_planet_id", on_delete: :cascade
  add_foreign_key "routes", "planets", column: "origin_planet_id", on_delete: :cascade
  add_foreign_key "ships", "pilots", on_delete: :cascade
  add_foreign_key "transactions", "contracts", on_delete: :nullify
end
