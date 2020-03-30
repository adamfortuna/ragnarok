class AddUidIndexes < ActiveRecord::Migration[6.0]
  def change
    add_index :items, :uid
    add_index :shops, :username
    add_index :shop_items, :item_id
    add_index :shop_items, :shop_id
  end
end
