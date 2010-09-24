class CreateDealerSizes < ActiveRecord::Migration

   def self.up
    create_table :dealer_sizes do |t|
      t.integer :country_id
      t.integer :dealer_size
      t.integer :q1
      t.integer :q2
      t.integer :q3
      t.integer :q4
      t.integer :all_year_from
       t.integer :all_year_to
      t.date :year

      t.timestamps
    end
  end

  def self.down
    drop_table :dealer_sizes
  end
end
