class CreateAdminRenaultCarparkDatas < ActiveRecord::Migration
  def self.up
    create_table :admin_renault_carpark_datas do |t|


      t.integer :dealer_number
      t.integer :number_of_car
      t.date :date_for
      t.integer :car_park_id
      t.timestamps
    end
    add_index :admin_renault_carpark_datas , :dealer_number
  end

  def self.down
    drop_table :admin_renault_carpark_datas
  end
end
