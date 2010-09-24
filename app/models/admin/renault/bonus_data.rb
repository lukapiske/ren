class Admin::Renault::BonusData < ActiveRecord::Base

  set_table_name "admin_renault_bonus_datas"
  belongs_to :bonus_target

  named_scope :for_month, lambda { |a| { :conditions => [ 'MONTH(date) =?', a ] } }
  named_scope :and_year, lambda { |a| { :conditions => [ 'YEAR(date) =?', a ] } }
  named_scope :until_month, lambda { |a| { :conditions => [ 'MONTH(date) >=?', a ] } }
  named_scope :interval, lambda { |a| { :conditions => [ 'DATE_SUB(CURDATE(),INTERVAL ? MONTH) <= date', a ] } }

  named_scope :in, lambda { |a| { :conditions => [ 'bir IN(?) ', a  ] }}
  named_scope :interval_for, lambda { |a, b| { :conditions => [ 'date >= ? AND date < ?    ', a, b  ] } }

end
