class CreateShops < ActiveRecord::Migration[6.0]
  def change
    create_table :shops do |t|
      t.string :title
      t.string :username
      t.string :location_map
      t.integer :location_x
      t.integer :location_y
      t.datetime :start_date
      t.string :shop_type
      t.boolean :open, default: true

      t.timestamps
    end
  end
end
