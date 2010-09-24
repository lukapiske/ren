class CreateAdminFactsheets < ActiveRecord::Migration
  def self.up
    create_table :admin_factsheets do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :admin_factsheets
  end
end
