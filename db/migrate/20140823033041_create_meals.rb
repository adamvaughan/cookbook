class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.integer :plan_id, null: false
      t.integer :recipe_id, null: false
      t.integer :day, null: false
      t.timestamps
    end
  end
end
