class Admin::Renault::A3reportsData < ActiveRecord::Base
    set_table_name "admin_renault_a3reports_datas"
    belongs_to :a3_report

#    named_scope :for_month, lambda { |a| { :conditions => [ 'MONTH(date_for) =?', a ] } }
#    named_scope :and_year, lambda { |a| { :conditions => [ 'YEAR(date_for) =?', a ] } }
#    named_scope :until_month, lambda { |a| { :conditions => [ 'MONTH(date_for) >=?', a ] } }
#    named_scope :interval, lambda { |a| { :conditions => [ 'DATE_SUB(CURDATE(),INTERVAL ? MONTH) <= date_for', a ] } }

    named_scope :in, lambda { |a| { :conditions => [ 'bir IN(?) ', a  ] }}
    named_scope :interval_for, lambda { |a, b| { :conditions => [ 'date_for >= ? AND date_for < ?    ', a, b  ] } }
end
