class CreateRoutes < ActiveRecord::Migration[7.1]
  def change
    create_table :routes, id: :uuid do |t|
      t.uuid :origin_planet_id, null: false, index: true
      t.uuid :destination_planet_id, null: false, index: true
      t.boolean :blocked, null: false, default: false
      t.integer :fuel_cost, null: false, default: 0

      t.timestamps
    end

    add_foreign_key :routes, :planets, column: :origin_planet_id, primary_key: :id, on_delete: :cascade
    add_foreign_key :routes, :planets, column: :destination_planet_id, primary_key: :id, on_delete: :cascade
    add_index :routes, [:origin_planet_id, :destination_planet_id], unique: true
  end
end
