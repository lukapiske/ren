class DealerBonus < ActiveRecord::Base





   #named_scope :percents, lambda { |a, b, c| { :select => c + ' AS bonus', :conditions => [ ' country_id= ? AND dealer_size = ? AND YEAR(year) = ? ', a, b, Date.today.year ] } }
   named_scope :percents, lambda { |a, b, c| { :select => c + ' AS bonus', :conditions => [ ' country_id= ? AND dealer_size = ? ', a, b ] } }






end
