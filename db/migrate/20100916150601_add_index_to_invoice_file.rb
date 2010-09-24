class AddIndexToInvoiceFile < ActiveRecord::Migration
def self.up
  add_index :admin_renault_invoice_datas, [:NROCTEDESS, :CODSEG ,:CODFAM ,:CODFAC, :CODFIL,:CODCON ]
end

def self.down
  remove_index :admin_renault_invoice_datas, [:NROCTEDESS, :CODSEG ,:CODFAM ,:CODFAC, :CODFIL,:CODCON]
end
end
