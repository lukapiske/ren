class CreateAdminRenaultCarsalesDatas < ActiveRecord::Migration
  def self.up
    create_table :admin_renault_carsales_datas do |t|
      t.string :code
      t.date :date
      t.string :acronym
      t.date :date_for
      t.integer :car_sale_id
      t.integer :bir
      t.string :model
      t.integer :time_stamp
      t.timestamps
    end
  end

  def self.down
    drop_table :admin_renault_carsales_datas
  end
end
