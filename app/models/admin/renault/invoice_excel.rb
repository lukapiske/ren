class Admin::Renault::InvoiceExcel < ActiveRecord::Base

  set_table_name "admin_renault_invoice_excels"

   cattr_reader :per_page
   @@per_page = 20

  has_attached_file :excelfiles, :styles => { :small => "150x150>" },
    :url => "/assets/invoices/:id/:style/:basename.:extension",
    :path => ":rails_root/public/assets/invoices/:id/:style/:basename.:extension"

  validates_attachment_presence :excelfiles
  validates_attachment_size :excelfiles, :less_than => 10.megabytes
  validates_attachment_content_type :excelfiles, :content_type => ['application/vnd.ms-excel']

  has_many :invoice_datas, :dependent => :destroy, :class_name => 'Admin::Renault::InvoiceData'

  validate :valid_name?

  private
  def valid_name?
    unless excelfiles.original_filename == 'sample_Invoicing_file.xls'
      errors.add(:excelfiles ,'does not fit - please check do you have right file')
    end
  end
end
