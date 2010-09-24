class Admin::Country < ActiveRecord::Base

  set_table_name "admin_countries"
  has_and_belongs_to_many :user , :foreign_key => 'id'
end
