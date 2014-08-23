class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.integer :recipe_id, null: false
      t.integer :index, null: false
      t.text :description, null: false
      t.timestamps
    end

    add_index :steps, [:recipe_id, :index], unique: true
  end
end
