class AddToUser < ActiveRecord::Migration
  def self.up
    add_column :admin_users, :name, :string
    add_column :admin_users, :surname, :string
    add_column :admin_users, :tel, :string
  end

  def self.down
  end
end
