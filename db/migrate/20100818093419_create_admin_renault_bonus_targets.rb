class CreateAdminRenaultBonusTargets < ActiveRecord::Migration
  def self.up
    create_table :admin_renault_bonus_targets do |t|
      
      t.string  :excelfiles_file_name
      t.string  :excelfiles_content_type
      t.string  :excelfiles_file_size
      t.string  :excelfiles_updated_at
      t.integer :user_id
      t.date    :date
      t.timestamps
    end
  end

  def self.down
    drop_table :admin_renault_bonus_targets
  end
end
