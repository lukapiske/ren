class Admin::User < ActiveRecord::Base

  set_table_name "admin_users"

  acts_as_authentic

  cattr_reader :per_page
  @@per_page = 5

  has_many :outlets, :primary_key => 'dealer_group_id', :foreign_key => 'dealer_group_id', :class_name => 'Admin::Outlet'
  has_one :role ,:primary_key => 'role_id', :foreign_key => 'id' , :class_name => 'Admin::Role'
  has_one :country, :primary_key => 'country_id', :foreign_key => 'id' , :class_name => 'Admin::Country'


  named_scope  :zone_manager, lambda { |a, b|  { :conditions => [ 'zone = ? AND role_id = 4 AND country_id = ?' , a, b ] } }

  def role_symbols
    #roles.map do |role|
      [ role.name.underscore.to_sym ]
    #end
  end
  def dealer_name
    outlets.first.dealer_ship_name
  end
#  def role
#    roles.last.name
#  end
  
end
