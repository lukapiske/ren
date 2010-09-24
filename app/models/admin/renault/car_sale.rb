class Admin::Renault::CarSale < ActiveRecord::Base
   set_table_name "admin_renault_car_sales"

    has_attached_file :excelfiles, :styles => { :small => "150x150" },
    :url => "/assets/car_sales/:id/:style/:basename.:extension",
    :path => ":rails_root/public/assets/car_sales/:id/:style/:basename.:extension"

  validates_attachment_presence :excelfiles
  validates_attachment_size :excelfiles, :less_than => 5.megabytes
  validates_attachment_content_type :excelfiles, :content_type => ['application/vnd.ms-excel']

  has_many :csales_datas, :dependent => :destroy,:class_name => 'Admin::Renault::CsalesData'

  validate :valid_name?

  private
  def valid_name?
    unless excelfiles.original_filename == 'sample_car_sales.xls'
      errors.add(:excelfiles ,'does not fit - please check do you have right file')
    end
  end
end
