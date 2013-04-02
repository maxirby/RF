class CreateHouses < ActiveRecord::Migration
  def change
    create_table :houses do |t|
      t.string :title
      t.text :description
      t.integer :flag
      t.integer :counter

      t.timestamps
    end
  end
end
