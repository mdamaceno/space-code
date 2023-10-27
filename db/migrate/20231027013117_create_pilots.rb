class CreatePilots < ActiveRecord::Migration[7.1]
  def change
    create_table :pilots, id: :uuid do |t|
      t.string :certification, null: false, limit: 7
      t.string :name, null: false
      t.integer :age, null: false

      t.timestamps
    end

    add_index :pilots, :certification, unique: true
  end
end
