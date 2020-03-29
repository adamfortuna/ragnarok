class RenameTypeColumns < ActiveRecord::Migration[6.0]
  def change
    rename_column :items, :type, :item_type
    rename_column :items, :subtype, :item_subtype
  end
end
