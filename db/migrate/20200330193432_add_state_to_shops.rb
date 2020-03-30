class AddStateToShops < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :state, :string
    add_index :shops, :state
    remove_column :shops, :open

    add_column :shop_items, :state, :string
    add_index :shop_items, :state
    remove_column :shop_items, :sold
    add_column :shop_items, :original_quantity, :integer
    add_column :shop_items, :transacted_quantity, :integer
  end
end
