
class Admin::Outlet < ActiveRecord::Base

   set_table_name "admin_outlets"

   cattr_reader :per_page
   @@per_page = 10

   named_scope :dealers, lambda { |country| { :conditions => [ 'country_id = ?' , country] ,:group => 'dealer_ship_name', :order => 'dealer_ship_name ASC'} }
   named_scope :zones, lambda { |country|  { :conditions => [ 'country_id = ?' , country] ,:group => 'zone', :order => 'zone ASC'} }
   named_scope :dealers_by_zone, lambda { |a,b| { :conditions => [ 'country_id = ? AND zone =?' , a,b] ,:group => 'dealer_ship_name', :order => 'dealer_ship_name ASC'} }
   named_scope :main_dealers, lambda { |a,b| { :conditions => [ 'country_id = ? AND zone =? AND contract_partner =?' , a,b,'Y'] , :group => 'dealer_group_id', :order => 'dealer_ship_name ASC'} }
   named_scope :just_main, :conditions =>  ['contract_partner =?', 'Y']
   named_scope :zone, lambda { |a| { :conditions => [ 'zone =?' , a] }}

  
 

   validates_presence_of :zone, :dealer_num,:dealer_ship_name,:outlet_name,:country_id,:dealer_group_id

   has_many :invoices_data , :primary_key => 'main_delivery', :foreign_key => 'NROCTEDESS', :class_name => 'Admin::Renault::InvoiceData'
   has_many :bonus_data , :primary_key => 'dealer_num', :foreign_key => 'bir', :class_name => 'Admin::Renault::BonusData'
   has_many :csales_data , :primary_key => 'dealer_num', :foreign_key => 'bir', :class_name => 'Admin::Renault::CsalesData'
   has_many :carpark_data , :primary_key => 'dealer_num', :foreign_key => 'dealer_number', :class_name => 'Admin::Renault::CarparkData'
   has_many :a3report_data , :primary_key => 'dealer_num', :foreign_key => 'bir', :class_name => 'Admin::Renault::A3reportsData'
   #it seems that model could reference him self :)
   has_many :outlet,:primary_key => 'dealer_group_id', :foreign_key => 'dealer_group_id', :class_name => 'Admin::Outlet'


#   attr_accessor :date
#
#    def initialize
#
#       @date = Date.today
#
#    end

   #calculate KPI for sliding month
   def axs_to_new_car
      a1 = self.invoices_data.segment('A').fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = self.invoices_data.segment('A').fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b = self.csales_data.interval_for(interval(4.month.ago), first_day).count(:id)
      divide(a, b)
   end
   def axs_to_new_car_x
      a1 = self.invoices_data.segment('A').fac_sum.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = self.invoices_data.segment('A').fac_sub.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b = self.csales_data.interval_for( interval(12.month.ago), first_day ).count(:id)
      divide(a, b)
   end
   def axs_to_new_car_y
      a1 = self.invoices_data.segment('A').fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = self.invoices_data.segment('A').fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b1 = self.invoices_data.segment('A').fac_sum.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b2 = self.invoices_data.segment('A').fac_sub.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b = b1 -b2
      divide(a, b)
   end
   def dealer_axs_to_new_car
      a1 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('A').fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('A').fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 -a2
      b = Admin::Renault::CsalesData.in(outlet_dealer_num_to_array).interval_for(interval(4.month.ago), first_day).count(:id)
      return divide(a , b)
   end
   def dealer_axs_to_new_car_x
      a1 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('A').fac_sum.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('A').fac_sub.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b = Admin::Renault::CsalesData.in(outlet_dealer_num_to_array).interval_for( interval(12.month.ago), first_day ).count(:id)
      return divide(a , b)
   end
   def dealer_axs_to_new_car_y
      a1 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('A').fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('A').fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b1 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('A').fac_sum.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b2 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('A').fac_sub.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b = b1 - b2
      return divide(a,b)
   end
   ####################################C M P ###############################################
   #calculate KPI for sliding month
   def cmp
      a1 = self.invoices_data.fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = self.invoices_data.fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b = self.carpark_data.and_year(today.year).sum(:number_of_car)
      divide(a, b)
   end
   def cmp_x
      a1 = self.invoices_data.fac_sum.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = self.invoices_data.fac_sub.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b = self.carpark_data.and_year(today.year).sum(:number_of_car)
      divide(a, b)
   end
   def cmp_y
      a1 = self.invoices_data.fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = self.invoices_data.fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b1 = self.invoices_data.fac_sum.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b2 = self.invoices_data.fac_sub.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b = b1 -b2
      divide(a, b)
   end
   def dealer_cmp
      a1 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 -a2
      b = Admin::Renault::CarparkData.in(outlet_dealer_num_to_array).and_year(today.year).sum(:number_of_car)
      return divide(a , b)
   end
   def dealer_cmp_x
      a1 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).fac_sum.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).fac_sub.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b = Admin::Renault::CarparkData.in(outlet_dealer_num_to_array).and_year(today.year).sum(:number_of_car)
      return divide(a , b)

   end
   def dealer_cmp_y
      a1 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b1 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).fac_sum.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b2 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).fac_sub.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b = b1 - b2
      return divide(a,b)
   end
   ###############################################################################
   def local_axs_to_new_car
      a1 = self.invoices_data.segment('A').local.fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = self.invoices_data.segment('A').local.fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b = self.csales_data.interval_for(interval(4.month.ago), first_day).count(:id)
      c = divide(a, b)
      l = divide(c, axs_to_new_car)
   end
   def local_axs_to_new_car_x
      a1 = self.invoices_data.segment('A').local.fac_sum.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = self.invoices_data.segment('A').local.fac_sub.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b = self.csales_data.interval_for( interval(12.month.ago), first_day ).count(:id)
      c = divide(a, b)
      l = divide(c, axs_to_new_car_x)
   end
   def local_axs_to_new_car_y
      a1 = self.invoices_data.segment('A').local.fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = self.invoices_data.segment('A').local.fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b1 = self.invoices_data.segment('A').local.fac_sum.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b2 = self.invoices_data.segment('A').local.fac_sub.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b = b1 -b2
      c = divide(a, b)
      l = divide(c, axs_to_new_car_y)
   end
   def dealer_local_axs_to_new_car
      a1 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('A').local.fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('A').local.fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 -a2
      b = Admin::Renault::CsalesData.in(outlet_dealer_num_to_array).interval_for(interval(4.month.ago), first_day).count(:id)
      c = divide(a, b)
      return divide(c, dealer_axs_to_new_car)
   end
   def dealer_local_axs_to_new_car_x
      a1 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('A').local.fac_sum.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('A').local.fac_sub.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b = Admin::Renault::CsalesData.in(outlet_dealer_num_to_array).interval_for( interval(12.month.ago), first_day ).count(:id)
      c = divide(a, b)
      return divide(c, dealer_axs_to_new_car_x)
   end
   def dealer_local_axs_to_new_car_y
      a1 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('A').local.fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('A').local.fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b1 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('A').local.fac_sum.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b2 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('A').local.fac_sub.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b = b1 - b2
      c = divide(a, b)
      return divide(c, dealer_axs_to_new_car_y)

   end
   ###############################################################################
   def cmp_body
      a1 = self.invoices_data.segment('C').fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = self.invoices_data.segment('C').fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b = self.carpark_data.and_year(today.year).sum(:number_of_car)
      divide(a, b)
   end
   def cmp_body_x
      a1 = self.invoices_data.segment('C').fac_sum.facture(13).interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = self.invoices_data.segment('C').fac_sub.facture(13).interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b = self.carpark_data.and_year(today.year).sum(:number_of_car)
      divide(a, b)
   end
   def cmp_body_y
      a1 = self.invoices_data.segment('C').fac_sum.facture(13).interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = self.invoices_data.segment('C').fac_sub.facture(13).interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b1 = self.invoices_data.segment('C').fac_sum.facture(13).interval_for( interval(16.month.ago), first_day.prev_year).sum(:sumOfPNCTOT)
      b2 = self.invoices_data.segment('C').fac_sub.facture(13).interval_for( interval(16.month.ago), first_day.prev_year).sum(:sumOfPNCTOT)
      b = b1 - b2
      divide(a, b)
   end
   def dealer_cmp_body
      a1 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('C').fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('C').fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b = Admin::Renault::CarparkData.in(outlet_dealer_num_to_array).and_year(today.year).sum(:number_of_car)
      return divide(a,b)
   end
   def dealer_cmp_body_x
      a1 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('C').fac_sum.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('C').fac_sum.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b = Admin::Renault::CarparkData.in(outlet_dealer_num_to_array).and_year(today.year).sum(:number_of_car)
      return divide(a,b)
   end
   def dealer_cmp_body_y
      a1 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('C').fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('C').fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b1 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('C').fac_sum.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b2 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('C').fac_sub.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b = b1 - b2
      return divide(a,b)
   end
   ###############################################################################
   def cmp_es
      a1 = self.invoices_data.segment('R').fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = self.invoices_data.segment('R').fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b = self.carpark_data.and_year(today.year).sum(:number_of_car)
      divide(a, b)
   end
   def cmp_es_x
      a1 = self.invoices_data.segment('R').fac_sum.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = self.invoices_data.segment('R').fac_sub.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b = self.carpark_data.and_year(today.year).sum(:number_of_car)
      divide(a, b)
   end
   def cmp_es_y
      a1 = self.invoices_data.segment('R').fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = self.invoices_data.segment('R').fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b1 = self.invoices_data.segment('R').fac_sum.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b2 = self.invoices_data.segment('R').fac_sub.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b = b1 - b2
      divide(a, b)
   end
   def dealer_cmp_es
      a1 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('R').fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('R').fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b = Admin::Renault::CarparkData.in(outlet_dealer_num_to_array).and_year(today.year).sum(:number_of_car)
      return divide(a,b)
   end
   def dealer_cmp_es_x
      a1 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('R').fac_sum.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('R').fac_sub.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b = Admin::Renault::CarparkData.in(outlet_dealer_num_to_array).and_year(today.year).sum(:number_of_car)
      return divide(a,b)
   end
   def dealer_cmp_es_y
      a1 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('R').fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('R').fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b1 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('R').fac_sum.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b2 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('R').fac_sub.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b = b1 - b2
      return divide(a,b)
   end
   ################################################################################
   def cmp_eu
      a1 = self.invoices_data.segments('E','U').fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = self.invoices_data.segments('E','U').fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b = self.carpark_data.and_year(today.year).sum(:number_of_car)
      divide(a, b)
   end
   def cmp_eu_x
      a1 = self.invoices_data.segments('E','U').fac_sum.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = self.invoices_data.segments('E','U').fac_sum.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b = self.carpark_data.and_year(today.year).sum(:number_of_car)
      divide(a, b)
   end
   def cmp_eu_y
      a1 = self.invoices_data.segments('E','U').fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = self.invoices_data.segments('E','U').fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b1 = self.invoices_data.segments('E','U').fac_sum.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b2 = self.invoices_data.segments('E','U').fac_sub.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b = b1 - b2
      divide(a, b)
   end
   def dealer_cmp_eu
      a1 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segments('E','U').fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segments('E','U').fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b = Admin::Renault::CarparkData.in(outlet_dealer_num_to_array).and_year(today.year).sum(:number_of_car)
      return divide(a,b)
   end
   def dealer_cmp_eu_x
      a1 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segments('E','U').fac_sum.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segments('E','U').fac_sub.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b = Admin::Renault::CarparkData.in(outlet_dealer_num_to_array).and_year(today.year).sum(:number_of_car)
      return divide(a,b)
   end
   def dealer_cmp_eu_y
      a1 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segments('E','U').fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segments('E','U').fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b1 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segments('E','U').fac_sum.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b2 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segments('E','U').fac_sub.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b = b1 - b2
      return divide(a, b)
   end
   ###############################################################################

   def motrio
      a1 = self.invoices_data.segment('K').fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = self.invoices_data.segment('K').fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b = cmp_eu
      divide(a, b)
   end
   def motrio_x
      a1 = self.invoices_data.segment('K').fac_sum.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = self.invoices_data.segment('K').fac_sum.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b = cmp_eu_x
      divide(a, b)
   end
   def motrio_y
      a1 = self.invoices_data.segment('K').fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 = self.invoices_data.segment('K').fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b1 = self.invoices_data.segment('K').fac_sum.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b2 = self.invoices_data.segment('K').fac_sub.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b = b1 - b2
      divide(a, b)
   end
   def dealer_motrio
      a1 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('K').fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('K').fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b = dealer_cmp_eu
      #return divide(a,b)
   end
   def dealer_motrio_x
      a1 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('K').fac_sum.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('K').fac_sub.interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b = dealer_cmp_eu_x
      return divide(a,b)
   end
   def dealer_motrio_y
      a1 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('K').fac_sum.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a2 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('K').fac_sub.interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b1 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('K').fac_sum.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b2 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('K').fac_sub.interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      b = b1 - b2
      return divide(a, b)
   end
   ################################################################################
   def tfa
      a = self.a3report_data.for_month.interval_for( interval(4.month.ago), first_day ).sum(:visit_total)
      b = self.carpark_data.and_year(today.year).sum(:number_of_car)
      divide(a, b)
   end
   def tfa_x
      a = self.a3report_data.for_month(today.month).interval_for( interval(12.month.ago), first_day ).sum(:visit_total)
      b = self.carpark_data.and_year(today.year).sum(:number_of_car)
      divide(a, b)
   end
   def tfa_y
      a = self.a3report_data.interval_for( interval(4.month.ago), first_day ).sum(:visit_total)
      b = self.a3report_data.interval_for( interval(4.month.ago), first_day ).sum(:visit_total_ly)
      divide(a, b)
   end
   def dealer_tfa
      a = Admin::Renault::A3reportsData.in(outlet_dealer_num_to_array).interval_for( interval(4.month.ago), first_day ).sum(:visit_total)
      b = Admin::Renault::CarparkData.in(outlet_dealer_num_to_array).and_year(today.year).sum(:number_of_car)
      return divide(a,b)
   end
   def dealer_tfa_x
      a = Admin::Renault::A3reportsData.in(outlet_dealer_num_to_array).interval_for( interval(12.month.ago), first_day ).sum(:visit_total)
      b = Admin::Renault::CarparkData.in(outlet_dealer_num_to_array).and_year(today.year).sum(:number_of_car)
      return divide(a,b)
   end
   def dealer_tfa_y
      a = Admin::Renault::A3reportsData.in(outlet_dealer_num_to_array).interval_for( interval(4.month.ago), first_day ).sum(:visit_total)
      b = Admin::Renault::A3reportsData.in(outlet_dealer_num_to_array).interval_for( interval(4.month.ago), first_day ).sum(:visit_total_ly)
      return divide(a,b)
   end
   ########################################################################################################
   def workshop_entries
      a = self.a3report_data.for_month.interval_for( interval(4.month.ago), first_day ).sum(:contact_total)
      b = self.carpark_data.and_year(today.year).sum(:number_of_car)
      divide(a, b)
      divide(a, b)
   end
   def workshop_entries_x
      a = self.a3report_data.for_month(today.month).interval_for( interval(12.month.ago), first_day ).sum(:contact_total)
      b = self.carpark_data.and_year(today.year).sum(:number_of_car)
      divide(a, b)
   end
   def workshop_entries_y
      a = self.a3report_data.interval_for( interval(4.month.ago), first_day ).sum(:contact_total)
      b = self.a3report_data.interval_for( interval(4.month.ago), first_day ).sum(:contact_total_ly)
      divide(a, b)
   end
   def dealer_workshop_entries
      a = Admin::Renault::A3reportsData.in(outlet_dealer_num_to_array).interval_for( interval(4.month.ago), first_day ).sum(:contact_total)
      b = Admin::Renault::CarparkData.in(outlet_dealer_num_to_array).and_year(today.year).sum(:number_of_car)
      return divide(a,b)
   end
   def dealer_workshop_entries_x
      a = Admin::Renault::A3reportsData.in(outlet_dealer_num_to_array).interval_for( interval(12.month.ago), first_day ).sum(:contact_total)
      b = Admin::Renault::CarparkData.in(outlet_dealer_num_to_array).and_year(today.year).sum(:number_of_car)
      return divide(a,b)
   end
   def dealer_workshop_entries_y
      a = Admin::Renault::A3reportsData.in(outlet_dealer_num_to_array).interval_for( interval(4.month.ago), first_day ).sum(:contact_total)
      b = Admin::Renault::A3reportsData.in(outlet_dealer_num_to_array).interval_for( interval(4.month.ago), first_day ).sum(:contact_total_ly)
      return divide(a,b)
   end
   ################################
   def target_achievements

      a1 =  self.invoices_data.fac_sum.interval_for( start_of_quarter(quarter), today ).sum(:sumOfPNCTOT)
      a2 =  self.invoices_data.fac_sub.interval_for( start_of_quarter(quarter), today ).sum(:sumOfPNCTOT)
      a = a1 - a2

      x = target_achievements_x
      y = target_achievements_y
      b = x + y
      percents =  ( divide( a , b ) ) * 100

   end
   def target_achievements_x
      @bonus = self.bonus_data.interval_for( start_of_quarter(quarter), end_of_quarter(quarter) ).sum(:target_q3_oe)
   end
   def target_achievements_y
      @bonus = self.bonus_data.interval_for( start_of_quarter(quarter), end_of_quarter(quarter) ).sum(:target_q3_am)
   end
  def invoice_target_ach
      a1 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).fac_sum.am.interval_for( start_of_quarter(quarter), today ).sum(:sumOfPNCTOT)
      a2 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).fac_sub.am.interval_for( start_of_quarter(quarter), today ).sum(:sumOfPNCTOT)
      a = a1 - a2
      b1 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).fac_sum.oe.interval_for( start_of_quarter(quarter), today ).sum(:sumOfPNCTOT)
      b2 =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).fac_sub.oe.interval_for( start_of_quarter(quarter), today ).sum(:sumOfPNCTOT)
      b = b1 - b2

      c = a + b
   end

   def dealer_target_achievements

      a = invoice_target_ach
      x = dealer_target_achievements_x
      y = dealer_target_achievements_y
      b = x + y
      
      percents =  ( divide( a , b ) ) * 100
      
      
   end

   def dealer_target_achievements_x
      b = Admin::Renault::BonusData.in(outlet_dealer_num_to_array).interval_for( start_of_quarter(quarter), end_of_quarter(quarter) ).sum(:target_q3_oe)
   end
   def dealer_target_achievements_y
      b = Admin::Renault::BonusData.in(outlet_dealer_num_to_array).interval_for( start_of_quarter(quarter), end_of_quarter(quarter) ).sum(:target_q3_am)
   end
   #############################

   def parts_urgent_orders
      a = self.invoices_data.facture(16).interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      b = self.csales_data.interval_for(interval(4.month.ago), first_day).count(:id)
      divide(a, b)
   end
   def parts_urgent_orders_x
      a = self.invoices_data.facture(16).interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      b = self.csales_data.interval_for( interval(12.month.ago), first_day ).count(:id)
      divide(a, b)
   end
   def parts_urgent_orders_y
      a = self.invoices_data.facture(16).interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      b = self.invoices_data.facture(16).interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPNCTOT)
      divide(a, b)
   end
   def dealer_parts_urgent_orders
      a = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).facture(16).interval_for( interval(4.month.ago), first_day ).sum(:sumOfPNCTOT)
      b = Admin::Renault::CsalesData.in(outlet_dealer_num_to_array).interval_for(interval(4.month.ago), first_day).count(:id)
      return divide(a,b)
   end
   def dealer_parts_urgent_orders_x
      a = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).facture(16).interval_for( interval(12.month.ago), first_day ).sum(:sumOfPNCTOT)
      b = Admin::Renault::CsalesData.in(outlet_dealer_num_to_array).interval_for( interval(12.month.ago), first_day ).count(:id)
      return divide(a,b)
   end
   def dealer_parts_urgent_orders_y
      a =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).facture(16).interval_for( interval(4.month.ago), first_day ).sum(:sumOfPCLTOT)
      b = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).facture(16).interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPCLTOT)
      return divide(a,b)
   end
   ##############################

   ##############################
   #calculate KPI for sliding month
   def windscreen
      a = self.invoices_data.codfam(861).interval_for( interval(4.month.ago), first_day ).sum(:sumOfPCLTOT)
      b = self.carpark_data.and_year(today.year).sum(:number_of_car)
      divide(a, b)
   end
   def windscreen_x
      a = self.invoices_data.codfam(861).interval_for( interval(12.month.ago), first_day ).sum(:sumOfPCLTOT)
      b = self.carpark_data.and_year(today.year).sum(:number_of_car)
      divide(a, b)
   end
   def windscreen_y
      a = self.invoices_data.codfam(861).interval_for( interval(4.month.ago), first_day ).sum(:sumOfPCLTOT)
      b = self.invoices_data.codfam(861).interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPCLTOT)
      divide(a, b)
   end
   def dealer_windscreen
      a =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).codfam(861).interval_for( interval(4.month.ago), first_day ).sum(:sumOfPCLTOT)
      b = Admin::Renault::CarparkData.in(outlet_dealer_num_to_array).and_year(today.year).sum(:number_of_car)
      return divide(a,b)
   end
   def dealer_windscreen_x
      a =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).codfam(861).interval_for( interval(12.month.ago), first_day ).sum(:sumOfPCLTOT)
      b = Admin::Renault::CarparkData.in(outlet_dealer_num_to_array).and_year(today.year).sum(:number_of_car)
      return divide(a,b)
   end
   def dealer_windscreen_y
      a =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).codfam(861).interval_for( interval(4.month.ago), first_day ).sum(:sumOfPCLTOT)
      b =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).codfam(861).interval_for( interval(16.month.ago), first_day.prev_year ).sum(:sumOfPCLTOT)
      return divide(a,b)
   end

  def quarter

      month =  Date.today.month.to_i
      a = [1, 2, 3]
      b = [4, 5, 6]
      c = [7, 8, 9]
      
      if a.include?(month)
         return 1
      elsif b.include?(month)
         return 2
      elsif c.include?(month)
         return 3
      else
         return 4
      end
   end
   def start_of_quarter(num)
      @year = Date.today.year
      quart = {

         1 => 1,
         2 => 4,
         3 => 7,
         4 => 10
      }
      Date.civil(Date.today.year, quart[num], 1)

   end
   def end_of_quarter(num)

      @year = Date.today.year
      quart = {

         1 => 3,
         2 => 6,
         3 => 9,
         4 => 12
      }
      Date.civil(Date.today.year, quart[num], -1)

   end
   def w_days_from(date)
      #      dif = DateTime.now - date
      #      return dif.to_i
      a = calculate_working_days(date , DateTime.now, [0,6])
      return a.to_i + 1
   end
   def w_days_to(date)

      #      dif = date - DateTime.now
      #      #      hours, mins, secs, ignore_fractions = Date::day_fraction_to_time(dif)
      #      #      days = hours / 24
      #      #+ one because we need to calculate last day in quarter
      #      return dif.to_i + 1

      a = calculate_working_days( DateTime.now, date, [0,6])
      return a.to_i
   end
   def w_days_in(from, to)

      dif = to - from

      #      hours, mins, secs, ignore_fractions = Date::day_fraction_to_time(dif)
      #      days = hours / 24
      #+ one because we need to calculate last day in quarter
      a = calculate_working_days(from , to, [0,6])
      return a.to_i

   end

   def calculate_working_days(d1,d2,wdays)
      diff = d2 - d1
      holidays = 0
      ret = (d2-d1).divmod(7)
      holidays =  ret[0].truncate * wdays.length
      d1 = d2 - ret[1]
      while(d1 <= d2)
         if wdays.include?(d1.wday)
            holidays += 1
         end
         d1 += 1
      end
      diff - holidays
   end


   private

   def outlet_dealer_num_to_array
      arr = Array.new
      outlet.each do |obj|
         arr.push obj.dealer_num
      end
      return arr
   end
   def outlet_invoice_id_to_array
      arr = Array.new
      outlet.each do |obj|
         arr.push obj.main_delivery
      end
      return arr
   end
   def timestamp_for(how)
      interval = Date.today.to_time - how.month.to_i
      return interval.to_i
   end
   def today
      Date.today
   end

  def first_day
      today =  Date.today
      first_date = Date.parse "#{today.year}-#{today.month}-01"
   end
   def interval(datum)
      today = datum
      interval = Date.parse "#{today.year}-#{today.month}-01"
   end
   def divide(num, num2)
      if num.to_i == 0
         "  "
      elsif num2.to_i == 0
         "  "
      else
         num.to_f / num2.to_f
      end
   end
end
