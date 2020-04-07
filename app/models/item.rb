class Item < ApplicationRecord
  ITEM_TYPES = {
    'IT_HEALING': 'Healing items',
    'IT_UNKNOWN': 'Unknown item type',
    'IT_USABLE': 'Other usable items',
    'IT_ETC': 'Misc items',
    'IT_WEAPON': 'Weapons',
    'IT_ARMOR': 'Armors',
    'IT_CARD': 'Cards',
    'IT_PETEGG': 'Pet eggs',
    'IT_PETARMOR': 'Pet accessories',
    'IT_UNKNOWN2': 'Unknown items (unused)',
    'IT_AMMO': 'Ammunitions',
    'IT_DELAYCONSUME': 'Consumable items (triggering additional actions)',
    'IT_CASH': 'Cash shop items'
  }.freeze
  ITEM_SUBTYPES = {
    'W_FIST': 'Unknown weapon (unused)',
    'W_DAGGER': 'Daggers',
    'W_1HSWORD': '1-hand swords',
    'W_2HSWORD': '2-hand swords',
    'W_1HSPEAR': '1-hand spears',
    'W_2HSPEAR': '2-hand spears',
    'W_1HAXE': '1-hand axes',
    'W_2HAXE': '2-hand axes',
    'W_MACE': '1-hand maces',
    'W_2HMACE': '2-hand maces',
    'W_STAFF': 'Staves',
    'W_BOW': 'Bows',
    'W_KNUCKLE': 'Knuckles',
    'W_MUSICAL': 'Musical instruments',
    'W_WHIP': 'WhipsW_BOOK: Books',
    'W_KATAR': 'Katars',
    'W_REVOLVER': 'Pistols',
    'W_RIFLE': 'Rifles',
    'W_GATLING': 'Gatling guns',
    'W_SHOTGUN': 'Shotguns',
    'W_GRENADE': 'Grenades',
    'W_HUUMA': 'Huuma shuriken',
    'A_ARROW': 'Arrows',
    'A_DAGGER': 'Throwing daggers',
    'A_BULLET': 'BulletsA_SHELL: Shells',
    'A_GRENADE': 'Grenades',
    'A_SHURIKEN': 'Shuriken',
    'A_KUNAI': 'Kunai',
    'A_CANNONBALL': 'Cannon balls',
    'A_THROWWEAPON': 'Other throwing weapons'
  }.freeze
  validates :uid, uniqueness: true
  validates :unique_name, uniqueness: true

  has_many :shop_items
  has_many :shops, through: :shop_items

  scope :opportunities, -> { where('best_selling_price < best_buying_price') }

  def nice_item_type
    ITEM_TYPES[item_type.to_sym] if item_type
  end
  def nice_item_subtype
    ITEM_SUBTYPES[item_subtype.to_sym] if item_subtype
  end

  def name_with_slots
    slots.nil? ? name : "#{name}[#{slots}]"
  end

  def market_opportunity
    return 0 if best_buying_price < best_selling_price

    best_buyer = shop_items.buying.where("price < #{best_selling_price}").first
    [selling_below_market_value.sum(:quantity), buying_above_market_value.sum(:quantity)].min * best_buyer.price
  end

  def selling_below_market_value
    shop_items.vending.active.where(["price < ?", item.best_buying_price])
  end

  def buying_above_market_value
    shop_items.buying.active.where(["price > ?", item.best_selling_price])
  end

  def avg_best_selling_price hours
    all_hours = (0..hours).to_a.collect do |hour|
      best_selling_price_at(hour.hours.ago, [hours.hours.ago, Time.now])
    end.compact

    avg(all_hours)
  end

  def mean_best_selling_price hours
    all_hours = (0..hours).to_a.collect do |hour|
      best_selling_price_at(hour.hours.ago, [hours.hours.ago, Time.now])
    end.compact

    mean(all_hours)
  end

  def avg arr
    arr.length == 0 ? 0 : arr.inject(0) { |result, el| result + el } / arr.length
  end

  def mean arr
    if arr.length == 0
      0
    elsif arr.length % 2 == 0
      n = arr.length/2
      (arr[n] + arr[n+1]) / 2
    else
      arr[arr.length/2]
    end
  end

  def best_prices start_time, end_time
    @best_prices = @best_prices || {}
    key = [start_time, end_time].join(',')
    @best_prices[key] = @best_prices[key] || ShopItem.where(item_id: id)
      .joins(:shop)
      .where(["start_date < ? AND (closed_date >= ? OR closed_date IS NULL)", start_time, end_time])
      .includes(:shop)
      .collect { |shop_item| {
        closed_date: shop_item.shop.closed_date,
        start_date: shop_item.shop.start_date,
        price: shop_item.price
      } }
  end

  # Get the percentage of hours this item was available
  def availability start_time, end_time
    hours = ((end_time - start_time) / 3600).round - 1
    available = (0..hours).to_a.collect do |hour|
      best_selling_price_at(start_time + hour.hours, [start_time, end_time])
    end.compact

    available.length*1.0 / (hours+1)*1.0 * 100
  end

  def best_selling_price_in start_time, end_time
    best_prices(start_time, end_time).collect { |shop_item| shop_item[:price] }.sort.first || "-"
  end

  def best_selling_price_at time, time_range
    best_prices(time_range.first, time_range.last).filter do |shop_item|
      shop_item[:start_date] <= time && (shop_item[:closed_date].nil? || shop_item[:closed_date] >= time)
    end.collect { |shop_item| shop_item[:price] }.sort.first
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
