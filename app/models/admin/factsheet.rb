class Admin::Factsheet < Admin::Outlet

  ########################################
  #       BASKET                         #
  ########################################

  def zone_manager(id, country)
    Admin::User.zone_manager(id, country)
  end


  ############# QUARTER TURNOVER #########

  def orginal_parts_quarter_to
    a =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).oe.interval_for( start_of_quarter(quarter), today ).sum(:sumOfPNCTOT)

  end

  def accessories_quarter_to
    a =  Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).am.interval_for( start_of_quarter(quarter), today ).sum(:sumOfPNCTOT)
  end
  def total_quarter_to
    orginal_parts_quarter_to + accessories_quarter_to
  end



  ########  ACHIEVEMENT  ################

  def achievement(turnover, target)
      
    divide((turnover * 100) , target)

  end

  def projection(turnover)

    d =  w_days_from(start_of_quarter(quarter))
    daily =  divide(turnover,  d )
    days_in_quarter = w_days_in(start_of_quarter(quarter), end_of_quarter(quarter))
    daily * days_in_quarter
   
  end

  def total_achievement

    dealer_target_achievements_x + dealer_target_achievements_y

  end

  #get size of dealer
  def size(country , turnover)

    @size = 1
    @sizes = DealerSize.sizes(country)
    @sizes.each do |d|
         
      next unless d.amount.to_i <= turnover.to_i
      @size = d.dealer_size
    end
      
    return @size

  end

  def bonus(country, turnover, percents)

    @size = size(country, turnover)
    @percent =  percents(country, @size, percents)

  end
  def bonus_amount(bonus, turnover)

    a = bonus.to_f * turnover.to_f
    divide( a  , 100 )

  end
  def next_level(country, turnover)

    @size = size(country, turnover)
    #because last size is size 4
    unless @size == 4
      @size += 1
    end

    @amount =  DealerSize.next_level(country, @size  ).last
    @amount.amount

  end
  #############################################################
  #                   END OF BASKET                           #
  #############################################################


  #############################################################
  #                   MONTHLY TO FOLLOW                       #
  #############################################################

  def get_monthly_to_follow(today)
    Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).year(today).monthly
  end

  def stock_purchase(obj)
    stock = Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).year(today).stock_monthly(obj.month)
    return  stock.last.stock_purchase
  end
  def stock(a,b)
    divide(a,b)*100
  end
  def urgent(a)
    100 - a
  end
  #############################################################
  #                 WEAR AND TEAR                             #
  #############################################################
  def get_wear_and_tear(quarter)
    Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('U').interval_for( start_of_quarter(quarter), end_of_quarter(quarter) )
  end
  def get_wear_and_tear_ly(quarter)
    Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('U').interval_for( start_of_quarter_ly(quarter), end_of_quarter_ly(quarter) )
  end
  #############################################################
  #                   accessories                             #
  #############################################################

  def accessories(quarter)
    Admin::Renault::InvoiceData.in(outlet_invoice_id_to_array).segment('A').interval_for( start_of_quarter(quarter), end_of_quarter(quarter) )
  end

  #############################################################
  #    country KPI                                            #
  #############################################################

  def country_cmp(id)

    a = Admin::Renault::InvoiceData.in(country_invoice_id_to_array(id)).interval_for( interval(4.month), first_day ).sum(:sumOfPNCTOT)
    b = Admin::Renault::CarparkData.in(country_dealer_num_to_array(id)).and_year(today.year).sum(:number_of_car)
    return divide(a , b)
      
  end
  ###########################################################
  def country_target_ach(id)

    a =  Admin::Renault::InvoiceData.in(country_invoice_id_to_array(id)).am.interval_for( start_of_quarter(quarter), today ).sum(:sumOfPNCTOT)
    b =  Admin::Renault::InvoiceData.in(country_dealer_num_to_array(id)).oe.interval_for( start_of_quarter(quarter), today ).sum(:sumOfPNCTOT)
    c = a + b

  end

  def country_target_achievements(id)

    a = country_target_ach(id)
    x = country_target_achievements_x(id)
    y = country_target_achievements_y(id)

    b = x + y
    percents =  ( divide( a , b ) ) * 100
     
  end

  def country_target_achievements_x(id)
    b = Admin::Renault::BonusData.in(country_dealer_num_to_array(id)).interval_for( start_of_quarter(quarter), end_of_quarter(quarter) ).sum(:target_q3_oe)
  end
  def country_target_achievements_y(id)
    b = Admin::Renault::BonusData.in(country_dealer_num_to_array(id)).interval_for( start_of_quarter(quarter), end_of_quarter(quarter) ).sum(:target_q3_am)
  end

  def country_axs_to_new_car(id)

    a = Admin::Renault::InvoiceData.in(country_invoice_id_to_array(id)).segment('A').interval_for( interval(4.month), first_day ).sum(:sumOfPNCTOT)
    b = Admin::Renault::CsalesData.in(country_dealer_num_to_array(id)).interval_for(interval(4.month), first_day).count(:id)
    return divide(a , b)
  end

  def country_cmp_body(id)

    a = Admin::Renault::InvoiceData.in(country_invoice_id_to_array(id)).segment('C').interval_for( interval(4.month), first_day ).sum(:sumOfPNCTOT)
    b = Admin::Renault::CarparkData.in(country_dealer_num_to_array(id)).and_year(today.year).sum(:number_of_car)
    return divide(a,b)
  end
  def country_cmp_es(id)

    a = Admin::Renault::InvoiceData.in(country_invoice_id_to_array(id)).segment('R').interval_for( interval(4.month), first_day ).sum(:sumOfPNCTOT)
    b = Admin::Renault::CarparkData.in(country_dealer_num_to_array(id)).and_year(today.year).sum(:number_of_car)
    return divide(a,b)
  end
  def country_cmp_eu(id)

    a =  Admin::Renault::InvoiceData.in(country_invoice_id_to_array(id)).segments('E','U').interval_for( interval(4.month), first_day ).sum(:sumOfPNCTOT)
    b =  Admin::Renault::CarparkData.in(country_dealer_num_to_array(id)).and_year(today.year).sum(:number_of_car)
    return divide(a,b)

  end
  def country_tfa(id)
      
    a = Admin::Renault::A3reportsData.in(country_dealer_num_to_array(id)).interval_for( interval(4.month), first_day ).sum(:visit_total)
    b = Admin::Renault::CarparkData.in(country_dealer_num_to_array(id)).and_year(today.year).sum(:number_of_car)
    return divide(a,b)
  end
  def country_parts_urgent_orders(id)

    a = Admin::Renault::InvoiceData.in(country_invoice_id_to_array(id)).facture(16).interval_for( interval(4.month), first_day ).sum(:sumOfPNCTOT)
    b = Admin::Renault::CsalesData.in(country_dealer_num_to_array(id)).interval_for(interval(4.month), first_day).count(:id)
    return divide(a,b)
  end
  def country_windscreen(id)

    a = Admin::Renault::InvoiceData.in(country_invoice_id_to_array(id)).codfam(861).interval_for( interval(4.month), first_day ).sum(:sumOfPCLTOT)
    b = Admin::Renault::CarparkData.in(country_dealer_num_to_array(id)).and_year(today.year).sum(:number_of_car)
    return divide(a,b)
  end
  def country_workshop_entries(id)
      
    a = Admin::Renault::A3reportsData.in(country_dealer_num_to_array(id)).interval_for( interval(4.month), first_day ).sum(:contact_total)
    b = Admin::Renault::CarparkData.in(country_dealer_num_to_array(id)).and_year(today.year).sum(:number_of_car)
    return divide(a,b)
  end
  def country_motrio(id)

    a =  Admin::Renault::InvoiceData.in(country_invoice_id_to_array(id)).segment('K').interval_for( interval(4.month), first_day ).sum(:sumOfPNCTOT)
    b =  Admin::Renault::InvoiceData.in(country_invoice_id_to_array(id)).segments('E','U').interval_for( interval(4.month), first_day ).sum(:sumOfPNCTOT)

    # b = country_cmp_eu(id)
    divide(a,b)
      
  end
  def country_local_axs_to_new_car(id)

    a = Admin::Renault::InvoiceData.in(country_invoice_id_to_array(id)).segment('A').local.interval_for( interval(4.month), first_day ).sum(:sumOfPNCTOT)
    b = Admin::Renault::CsalesData.in(country_dealer_num_to_array(id)).interval_for(interval(4.month), first_day).count(:id)
    c = divide(a, b)
    return divide(c, country_axs_to_new_car(id))
  end
  ############################################################
  #                                                          #
  ############################################################

  def cvc(a,b)
      
    c = divide(a , b)

    if(c != 0 )
      return c - 1
    else
      I18n.t('info.no_data')
    end
      
    
  end
  def cvcly(a,b)

    c = divide(a , b)

  end


  def country_dealer_num_to_array(id)
    arr = Array.new
    Admin::Outlet.in_country(id).each do |obj|
      arr.push obj.dealer_num
    end
    return arr
  end
  def country_invoice_id_to_array(id)
    arr = Array.new
    Admin::Outlet.in_country(id).each do |obj|
      arr.push obj.main_delivery
      arr.push obj.urgent_track
    end
    return arr
  end


  private
  def percents( country, size , percent)

    #size_one , size_two is actualy name of db column which is send to named_scope as argument
    a = percent.to_i
    if a <= 80
      per =  "size_one"
    elsif a <= 90
      per =  "size_two"
    elsif a <= 99
      per =  "size_three"
    elsif a == 100
      per =  "size_four"
    elsif a <= 110
      per = "size_five"
    else
      per = "size_max"
    end

    data =  DealerBonus.percents(country, size, per ).last

    realbonus = data.bonus
    #if size between 100 - 110 then take bonus for 100 and each percent over 100 , multyply with size five
    if per == "size_five"
      #for 100
      d =  DealerBonus.percents( country, size, 'size_four' ).last.bonus
      #for size_five
      e =  DealerBonus.percents( country, size, per ).last.bonus
      #difference
      s =  a - 100
      realbonus = d.to_f + ( s.to_f * e.to_f)
         
    end
    return realbonus
  end
end
