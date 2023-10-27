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

ActiveRecord::Schema[7.1].define(version: 2023_10_27_013117) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pilots", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "certification", limit: 7, null: false
    t.string "name", null: false
    t.integer "age", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["certification"], name: "index_pilots_on_certification", unique: true
  end

  create_table "planets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_planets_on_name", unique: true
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

  add_foreign_key "routes", "planets", column: "destination_planet_id", on_delete: :cascade
  add_foreign_key "routes", "planets", column: "origin_planet_id", on_delete: :cascade
end
