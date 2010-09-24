class Admin::Renault::CsalesData < ActiveRecord::Base

  set_table_name "admin_renault_carsales_datas"

  belongs_to :car_sale
  named_scope :grouped , :group => 'date, acronym, model', :select => ' *, COUNT(date) AS car_num'

  #not used
  #pass number of months - for example if you want all results from 4 months ago till today : get_interval(4)
  named_scope :get_interval, lambda { |a| { :conditions => [ "time_stamp > ?", a.to_s ]  }}

  named_scope :car_model, lambda { |a| { :conditions => [ 'model = ?', a ] } }
  named_scope :car_type, lambda { |a| { :conditions => [ 'acronym = ?', a ] } }


#  named_scope :for_month, lambda { |a| { :conditions => [ 'MONTH(date) =?', a ] } }
#  named_scope :and_year, lambda { |a| { :conditions => [ 'YEAR(date) =?', a ] } }
#  named_scope :until_month, lambda { |a| { :conditions => [ 'MONTH(date) >=?', a ] } }
#  named_scope :interval, lambda { |a| { :conditions => [ 'DATE_SUB(CURDATE(),INTERVAL ? MONTH) <= date', a ] } }

 named_scope :interval_for, lambda { |a, b| { :conditions => [ 'date >= ? AND date < ?    ', a, b  ] } }

  named_scope :in, lambda { |a| { :conditions => [ 'bir IN(?) ', a  ] }}





end
