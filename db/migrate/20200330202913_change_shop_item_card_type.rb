class ChangeShopItemCardType < ActiveRecord::Migration[6.0]
  def change
    remove_column :shop_items, :cards
    add_column :shop_items, :cards, :integer, array: true
    add_index :shop_items, :cards, using: 'gin'
  end
end
