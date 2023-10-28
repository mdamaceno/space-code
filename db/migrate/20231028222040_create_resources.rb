class CreateResources < ActiveRecord::Migration[7.1]
  def change
    create_table :resources, id: :uuid do |t|
      t.string :name, null: false
      t.integer :weight, null: false, default: 0
      t.uuid :contract_id, null: false

      t.timestamps
    end

    add_foreign_key :resources, :contracts, column: :contract_id, primary_key: :id, on_delete: :cascade
  end
end
