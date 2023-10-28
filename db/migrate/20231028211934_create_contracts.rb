class CreateContracts < ActiveRecord::Migration[7.1]
  def change
    create_table :contracts, id: :uuid do |t|
      t.string :description, null: false
      t.uuid :origin_planet_id, null: false
      t.uuid :destination_planet_id, null: false
      t.uuid :ship_id
      t.datetime :completed_at
      t.integer :value, null: false, default: 0

      t.timestamps
    end

    add_foreign_key :contracts, :planets, column: :origin_planet_id, primary_key: :id, on_delete: :cascade
    add_foreign_key :contracts, :planets, column: :destination_planet_id, primary_key: :id, on_delete: :cascade
    add_foreign_key :contracts, :ships, column: :ship_id, primary_key: :id, on_delete: :nullify
  end
end
