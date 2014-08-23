class CreateListItems < ActiveRecord::Migration
  def change
    create_table :list_items do |t|
      t.integer :list_id, null: false
      t.integer :quantity, null: false
      t.string :measurement
      t.string :description, null: false
      t.boolean :purchased, default: false
      t.boolean :manually_added, default: false
      t.timestamps
    end
  end
end
