class DealerSize < ActiveRecord::Base

   set_table_name "dealer_sizes"
 
   #named_scope :sizes ,lambda { |a , b| :conditions => [ 'q1 = ?'  ] , a ,b }

   #named_scope :sizes, lambda { |a| { :select => "dealer_size, q"+Admin::Factsheet.last.quarter.to_s+" AS amount ", :conditions => [ ' country_id= ? AND YEAR(year) = ? ', a, Date.today.year ] } }
   #named_scope :next_level, lambda { |a, b| { :select => "dealer_size, q"+Admin::Factsheet.last.quarter.to_s+" AS amount ", :conditions => [ ' country_id= ? AND YEAR(year) = ? AND dealer_size = ? ', a, Date.today.year, b ] } }

   named_scope :sizes, lambda { |a| { :select => "dealer_size, q"+Admin::Factsheet.last.quarter.to_s+" AS amount ", :conditions => [ ' country_id= ?', a] } }
   named_scope :next_level, lambda { |a, b| { :select => "dealer_size, q"+Admin::Factsheet.last.quarter.to_s+" AS amount ", :conditions => [ ' country_id= ?  AND dealer_size = ? ', a, b ] } }



end
