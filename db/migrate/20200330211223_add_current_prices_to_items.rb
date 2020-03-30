class AddCurrentPricesToItems < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :best_selling_price, :integer
    add_column :items, :best_buying_price, :integer
  end
end
