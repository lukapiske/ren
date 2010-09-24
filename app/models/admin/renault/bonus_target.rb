class Admin::Renault::BonusTarget < ActiveRecord::Base
  set_table_name "admin_renault_bonus_targets"

  has_attached_file :excelfiles, :styles => { :small => "150x150" },
    :url => "/assets/bonus/:id/:style/:basename.:extension",
    :path => ":rails_root/public/assets/bonus/:id/:style/:basename.:extension"

  validates_attachment_presence :excelfiles
  validates_attachment_size :excelfiles, :less_than => 5.megabytes
  validates_attachment_content_type :excelfiles, :content_type => ['application/vnd.ms-excel']

  has_many :bonus_datas, :dependent => :destroy, :class_name => 'Admin::Renault::BonusData'

  validate :valid_name?

  private
  def valid_name?
    unless excelfiles.original_filename == 'sample_bonus_target.xls'
      errors.add(:excelfiles ,'does not fit - please check do you have right file')
    end
  end
end
