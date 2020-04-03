class Shop < ApplicationRecord
  has_many :shop_items
  has_many :items, through: :shop_items

  scope :open, -> { where(state: 'Open') }
  scope :updating, -> { where(state: 'Updating') }
  scope :closed, -> { where(state: 'Closed') }

  def self.sync!
    # Mark all open shops as currently updating
    Shop.open.update_all "state='Updating'"

    # Get all shops currently out there.
    OriginApi.shops.each do |server_market|
      Shop.find_or_initialize_by(username: server_market['owner'], start_date: server_market['creation_date']).tap do |shop|
        shop.transaction do
          shop.title = server_market['title']
          shop.location_map = server_market['location']['map']
          shop.location_x = server_market['location']['x']
          shop.location_y = server_market['location']['y']
          shop.shop_type = server_market['type']
          shop.save!

          shop.shop_items.active.update_all "state='Updating'"

          # Go through the items currently in the shop and update them
          server_market['items'].each do |server_item|
            begin
              shop.shop_items.updating.find_or_initialize_by(item_id: Item.find_by(uid: server_item['item_id']).id,
                                                             price: server_item['price'],
                                                             refine: server_item['refine'],
                                                             cards: server_item['cards'],
                                                             element: server_item['element'],
                                                             star_crumbs: server_item['star_crumbs'],
                                                             forger: server_item['creator'],
                                                             beloved: server_item['beloved']
                                                           ).tap do |shop_item|
                # Save the original number of this item that were there to be sold
                if shop_item.new_record?
                  shop_item.original_quantity = server_item['amount']
                end

                shop_item.quantity = server_item['amount']
                shop_item.transacted_quantity = shop_item.original_quantity - server_item['amount']

                shop_item.state = 'Active'
                shop_item.save!
              rescue Exception => e
                byebug
              end
            end
          end

          # Any shop items that aren't active were sold. Mark them as sold
          shop.shop_items.updating.each do |shop_item|
            shop_item.update_attributes({
              transacted_quantity: shop_item.original_quantity,
              quantity: 0,
              state: 'Sold'
            })
          end

          shop.state = 'Open'
          shop.save!
        end
      end
    end

    # Mark all shop items that we don't know about as neither sold or unsold
    Shop.updating.each do |shop|
      shop.shop_items.active.update_all "state='Unsold'"
    end
    Shop.updating.update_all ["closed_date=?", Time.now]
    Shop.updating.update_all "state='Closed'"
  end
end
