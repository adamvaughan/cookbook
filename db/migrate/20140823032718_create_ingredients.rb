class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.integer :recipe_id, null: false
      t.integer :index, null: false
      t.string :quantity
      t.string :measurement
      t.string :description, null: false
      t.text :notes
      t.timestamps
    end

    add_index :ingredients, [:recipe_id, :index], unique: true
  end
end
