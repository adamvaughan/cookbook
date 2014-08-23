class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.integer :month, null: false
      t.integer :year, null: false
      t.timestamps
    end

    add_index :plans, [:month, :year], unique: true
  end
end
