class Item < ApplicationRecord
  validates :uid, uniqueness: true
  validates :unique_name, uniqueness: true

  has_many :shop_items
  has_many :shops, through: :shop_items

  scope :opportunities, -> { where('best_selling_price < best_buying_price') }

  def market_opportunity
    return 0 if best_buying_price < best_selling_price

    best_shop = shop_items.vending.where("price > #{best_buying_price}").first
    best_buyer = shop_items.buying.where("price < #{best_selling_price}").first

    if best_shop && best_buyer
      available_quantity = [best_shop.quantity, best_buyer.quantity].min
      (best_shop.price * available_quantity) - (available_quantity * best_buyer.price)
    else
      0
    end
  end

  def self.sync!
    # Items
    OriginApi.items.each do |server_item|
      Item.find_or_initialize_by(uid: server_item['item_id']).tap do |item|
        item.unique_name = server_item['unique_name']
        item.name = server_item['name']
        item.item_type = server_item['type']
        item.item_subtype = server_item['subtype']
        item.npc_price = server_item['npc_price']
        item.slots = server_item['slots']
        item.save
      end
    end

    # Items
    OriginApi.icons.each do |server_icon|
      Item.find_or_initialize_by(uid: server_icon['item_id']).tap do |item|
        item.icon = server_icon['icon']
        item.save
      end
    end
  end

  def self.best_prices!
    Item.all.each do |item|
      item.best_selling_price = ShopItem.vending.where(item_id: item.id).order(:price).first.try(:price)
      item.best_buying_price = ShopItem.buying.where(item_id: item.id).order(price: :desc).first.try(:price)
      item.save
    end
  end
end
