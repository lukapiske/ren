class CreateAdminOutlets < ActiveRecord::Migration
  def self.up

    create_table :admin_outlets do |t|
      t.string :zone
      t.integer :dealer_num
      t.string :dealer_ship_name
      t.string :outlet_name
      t.string :address
      t.string :zip
      t.string :place
      t.string :contract_partner
      t.integer :main_delivery
      t.integer :urgent_track
      t.integer :dealer_group_id
      t.string :country
      t.integer :country_id

      t.timestamps
    end
  end

  def self.down
    drop_table :admin_outlets
  end
end
