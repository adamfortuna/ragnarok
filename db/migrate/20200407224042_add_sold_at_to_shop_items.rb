class AddSoldAtToShopItems < ActiveRecord::Migration[6.0]
  def change
    add_column :shop_items, :sold_at, :datetime



    # Use the date the store opened as a reference date for undated items
    ShopItem.where(state: 'Sold').includes(:shop).each do |shop_item|
      shop_item.update_attribute(:sold_at, shop_item.shop.start_date)
    end
  end
end
