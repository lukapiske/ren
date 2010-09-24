class Admin::Renault::CarparkData < ActiveRecord::Base

  set_table_name "admin_renault_carpark_datas"

  belongs_to :car_park

#  named_scope :for_month, lambda { |a| { :conditions => [ 'MONTH(date_for) =?', a ] } }
#  named_scope :until_month, lambda { |a| { :conditions => [ 'MONTH(date_for) >=?', a ] } }
#  named_scope :interval, lambda { |a| { :conditions => [ 'DATE_SUB(CURDATE(),INTERVAL ? MONTH) <= date_for', a ] } }

  named_scope :and_year, lambda { |a| { :conditions => [ 'YEAR(date_for) =?', a ] } }
  named_scope :in, lambda { |a| { :conditions => [ 'dealer_number IN(?) ', a  ] }}
end
