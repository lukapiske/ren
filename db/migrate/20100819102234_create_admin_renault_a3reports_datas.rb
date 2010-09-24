class CreateAdminRenaultA3reportsDatas < ActiveRecord::Migration
  def self.up
    create_table :admin_renault_a3reports_datas do |t|


      t.integer :outlets_id
      t.string  :name
      t.integer :contact_total
      t.integer :contact_total_ly
      t.integer :visit_total
      t.integer :visit_total_ly
      t.date    :date_for
      t.integer :bir
      t.integer :a3_report_id
      t.timestamps
    end
    add_index :admin_renault_a3reports_datas , :bir
    add_index :admin_renault_a3reports_datas , :a3_report_id
  end

  def self.down
    drop_table :admin_renault_a3reports_datas
  end
end
