class CreatePlanets < ActiveRecord::Migration[7.1]
  def change
    create_table :planets, id: :uuid do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :planets, :name, unique: true
  end
end
