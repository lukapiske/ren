class CreateAdminRenaultBonusDatas < ActiveRecord::Migration
  def self.up
    create_table :admin_renault_bonus_datas do |t|
      t.integer :bir
      t.string :name
      t.integer :target_q3_oe
      t.integer :target_q3_am
      t.date :date
      t.integer :bonus_target_id

      t.timestamps
    end
    add_index :admin_renault_bonus_datas , :bonus_target_id
  end

  def self.down
    drop_table :admin_renault_bonus_datas
  end
end
