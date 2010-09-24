class CreateDealerBonus < ActiveRecord::Migration
  def self.up
    create_table :dealer_bonus do |t|
      t.integer :country_id
      t.integer :dealer_size
      t.float :size_one
      t.float :size_two
      t.float :size_three
      t.float :size_four
      t.float :size_five
      t.float :size_max
      t.date :year

      t.timestamps
    end
  end

  def self.down
    drop_table :dealer_bonus
  end
end
