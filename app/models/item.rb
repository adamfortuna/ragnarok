class Item < ApplicationRecord
  validates :uid, uniqueness: true
  validates :unique_name, uniqueness: true

  has_many :shop_items
  has_many :shops, through: :shop_items

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
end
