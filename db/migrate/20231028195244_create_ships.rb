class CreateShips < ActiveRecord::Migration[7.1]
  def change
    create_table :ships, id: :uuid do |t|
      t.string :name, null: false
      t.integer :fuel_capacity, null: false, default: 0
      t.integer :fuel_level, null: false, default: 0
      t.integer :weight_capacity, null: false, default: 0
      t.uuid :pilot_id, null: false

      t.timestamps
    end

    add_foreign_key :ships, :pilots, column: :pilot_id, primary_key: :id, on_delete: :cascade
  end
end
