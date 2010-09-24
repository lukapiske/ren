class AddCodconToInvoicesData < ActiveRecord::Migration
  def self.up
    add_column :admin_renault_invoice_datas, :CODCON, :integer
  end

  def self.down
     remove_column :admin_renault_invoice_datas, :CODCON, :integer
  end
end
