class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :admin_users do |t|
      t.string :username
      t.string :email
      t.string :persistence_token
      t.string :crypted_password
      t.string :password_salt
      t.integer :role_id
      t.integer :country_id
      t.integer :dealer_group_id
      t.integer :role_id
      t.string :zone

      t.timestamps
    end
  end
  
  def self.down
    drop_table :admin_users
  end
end
