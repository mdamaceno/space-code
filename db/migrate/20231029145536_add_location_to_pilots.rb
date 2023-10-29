class AddLocationToPilots < ActiveRecord::Migration[7.1]
  def change
    add_column :pilots, :planet_id, :uuid
    add_foreign_key :pilots, :planets, column: :planet_id, primary_key: :id, on_delete: :nullify
  end
end
