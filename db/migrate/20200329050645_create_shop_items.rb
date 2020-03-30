class CreateShopItems < ActiveRecord::Migration[6.0]
  def change
    enable_extension "hstore"
    
    create_table :shop_items do |t|
      t.integer :shop_id
      t.integer :item_id
      t.integer :quantity
      t.integer :price
      t.integer :refine
      t.hstore :cards
      t.integer :star_crumbs
      t.string :element
      t.integer :forger
      t.boolean :beloved
      t.boolean :sold, default: false
    end
  end
end
