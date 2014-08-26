class ChangeListItemQuantityToDecimal < ActiveRecord::Migration
  def change
    change_column :list_items, :quantity, :decimal, null: false
  end
end
