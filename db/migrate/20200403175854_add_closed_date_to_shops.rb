class AddClosedDateToShops < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :closed_date, :datetime
  end
end
