class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.integer :uid
      t.string :unique_name
      t.string :name
      t.string :type
      t.string :subtype
      t.integer :npc_price
      t.integer :slots
      t.text :icon

      t.timestamps
    end
  end
end
