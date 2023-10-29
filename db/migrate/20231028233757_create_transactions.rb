class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions, id: :uuid do |t|
      t.string :certification, null: false
      t.string :kind, null: false
      t.integer :amount, null: false, default: 0
      t.string :description, null: false, default: ''
      t.uuid :contract_id

      t.timestamps
    end

    add_foreign_key :transactions, :contracts, column: :contract_id, primary_key: :id, on_delete: :nullify
  end
end
