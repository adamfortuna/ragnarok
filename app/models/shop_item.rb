class ShopItem < ApplicationRecord
  belongs_to :shop
  belongs_to :item

  scope :updating, -> { where(state: 'Updating') } # During the update process
  scope :unsold, -> { where(state: 'Unsold') } # After a shop has sold
  scope :active, -> { where(state: 'Active') } # Currently Vending

  scope :vending, -> { joins(:shop).where(shops: { shop_type: 'V'}).includes(:shop) }
  scope :buying, -> { joins(:shop).where(shops: { shop_type: 'B'}).includes(:shop) }
end
