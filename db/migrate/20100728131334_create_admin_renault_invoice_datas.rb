class CreateAdminRenaultInvoiceDatas < ActiveRecord::Migration
  def self.up
    create_table :admin_renault_invoice_datas do |t|

      t.integer :CODFIL
      t.integer :NROCTEDESS
      t.string  :CODSEG
      t.integer :CODFAM
      t.integer :CODFAC
      t.decimal :sumOfPNCTOT
      t.decimal :sumOfPCLTOT
      t.decimal :sumOfTEFAC
      t.integer :is_deleted
      t.integer :invoice_excel_id
      t.date :DATCRE

      t.timestamps
    end
    add_index :admin_renault_invoice_datas , :CODFIL
    add_index :admin_renault_invoice_datas , :NROCTEDESS
    add_index :admin_renault_invoice_datas , :invoice_excel_id
    add_index :admin_renault_invoice_datas , :DATCRE
  end

  def self.down
    drop_table :admin_renault_invoice_datas
  end
end
