class CreateAdminCountries < ActiveRecord::Migration
  def self.up
    create_table :admin_countries do |t|
      t.string :name
      t.integer :code

      t.timestamps
    end
  end

  def self.down
    drop_table :admin_countries
  end
end
