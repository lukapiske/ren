class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :admin_roles do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :admin_roles
  end
end
