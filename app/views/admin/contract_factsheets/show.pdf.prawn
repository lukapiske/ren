@datas = @outlet

stef = "#{RAILS_ROOT}/public/images/renault.png"
pdf.image stef, :position => :left,  :scale => 0.2, :vposition => :top , :width => 50, :height => 50

pdf.move_down(20)

pdf.text "Dealer #{@datas.dealer_ship_name} #{@datas.date}", :size => 10, :style => :bold, :color => :red, :align => :center

pdf.move_down(20)

man = @datas.zone_manager(@datas.zone, @datas.country_id)

if !man.empty?
   manager = "#{man.first.name} #{man.first.surname}"
end
items =
  [[
      @datas.dealer_num,
      @datas.dealer_ship_name,
      @datas.country,
      @datas.zone,
      manager,
      @datas.main_delivery
   ]]

pdf.table items, :border_style => :grid,
  :row_colors => ["FAB500","E9EBE7"],
  :align => :center,:font_size => 8,
  :headers =>  [ I18n.t('excel_output.bir_no'),
   I18n.t('excel_output.dealer_name'),
   I18n.t('excel_output.country'),
   I18n.t('excel_output.zone'),
   I18n.t('excel_output.zone_manager'),
   I18n.t('excel_output.sigmpr') ]




pdf.move_down(20)


outlet = @outlet

@uarterTarget1 =  outlet.dealer_target_achievements_x
@uarterTarget2 =  outlet.dealer_target_achievements_y
@uarterTarget3 =  outlet.total_achievement

@quarterTurnover1 = outlet.orginal_parts_quarter_to
@quarterTurnover2 = outlet.projection(outlet.orginal_parts_quarter_to)
@quarterTurnover3 = outlet.accessories_quarter_to
@quarterTurnover4 = outlet.projection(outlet.accessories_quarter_to)
@quarterTurnover5 = outlet.total_quarter_to
@quarterTurnover6 = outlet.projection(outlet.total_quarter_to)

@achievement1 = outlet.achievement(@quarterTurnover1 , @uarterTarget1)
@achievement2 = outlet.achievement(@quarterTurnover2,  @uarterTarget1)
@achievement3 = outlet.achievement(@quarterTurnover3,  @uarterTarget2)
@achievement4 = outlet.achievement(@quarterTurnover4,  @uarterTarget2)
@achievement5 = outlet.achievement(@quarterTurnover5,  @uarterTarget3)
@achievement6 = outlet.achievement(@quarterTurnover6,  @uarterTarget3)

@bonus1 = outlet.bonus(outlet.country_id, @quarterTurnover1, @achievement1)
@bonus2 = outlet.bonus(outlet.country_id, @quarterTurnover2, @achievement2)
@bonus3 = outlet.bonus(outlet.country_id, @quarterTurnover3, @achievement3)
@bonus4 = outlet.bonus(outlet.country_id, @quarterTurnover4, @achievement4)
@bonus5 = outlet.bonus(outlet.country_id, @quarterTurnover5, @achievement5)
@bonus6 = outlet.bonus(outlet.country_id, @quarterTurnover6, @achievement6)

width_a = 75
width_b = 150
color_a = 'FAB500'

data = [ [
      {:text => "",:width => width_a,:background_color => color_a },
      {:text => I18n.t('basket.o_parts'),     :font_style => :bold, :colspan => 2 ,:background_color => color_a,:width => width_b  },
      {:text => I18n.t('basket.accessories'), :font_style => :bold, :colspan => 2, :background_color => color_a,:width => width_b },
      {:text => I18n.t('basket.total'),       :font_style => :bold, :colspan => 2,:background_color =>  color_a,:width => width_b  } ],


   [  { :text => "", :width => width_a ,:background_color => color_a} ,
      { :text => I18n.t('basket.achived'), :width => width_a },
      { :text => I18n.t('basket.projection'),:width => width_a  },
      { :text => I18n.t('basket.achived'),:width => width_a  },
      { :text => I18n.t('basket.projection'),:width => width_a  },
      { :text => I18n.t('basket.achived'),:width => width_a  },
      { :text => I18n.t('basket.projection'),:width => width_a  }
   ],

   [ { :text => I18n.t('basket.q_target'), :background_color => color_a, :width => width_a } ,
      { :text => number_to_currency(@uarterTarget1, :unit => "€", :format => "%n %u") , :colspan =>  2,:width => width_b },
      { :text => number_to_currency(@uarterTarget2, :unit => "€", :format => "%n %u") , :colspan =>  2,:width => width_b },
      { :text => number_to_currency(@uarterTarget3, :unit => "€", :format => "%n %u") , :colspan =>  2,:width => width_b }],

   [ { :text => I18n.t('basket.q_turnover'), :background_color => color_a, :width => width_a  } ,
      { :text => number_to_currency(@quarterTurnover1, :unit => "€", :format => "%n %u"),:width => width_a   },
      { :text => number_to_currency(@quarterTurnover2, :unit => "€", :format => "%n %u"),:width => width_a   },
      { :text => number_to_currency(@quarterTurnover3, :unit => "€", :format => "%n %u"),:width => width_a   },
      { :text => number_to_currency(@quarterTurnover4, :unit => "€", :format => "%n %u"),:width => width_a   },
      { :text => number_to_currency(@quarterTurnover5, :unit => "€", :format => "%n %u"),:width => width_a   },
      { :text => number_to_currency(@quarterTurnover6, :unit => "€", :format => "%n %u"),:width => width_a } ],

   [ { :text => I18n.t('basket.achievement'), :background_color => color_a, :width => width_a  } ,
      { :text => number_to_percentage(@achievement1, :precision => 2),:width => width_a   },
      { :text => number_to_percentage(@achievement2, :precision => 2),:width => width_a   },
      { :text => number_to_percentage(@achievement3, :precision => 2),:width => width_a   },
      { :text => number_to_percentage(@achievement4, :precision => 2),:width => width_a   },
      { :text => number_to_percentage(@achievement5, :precision => 2),:width => width_a   },
      { :text => number_to_percentage(@achievement6, :precision => 2),:width => width_a } ],

   [ { :text => I18n.t('basket.b_amount'), :background_color => color_a, :width => width_a  } ,
      { :text => number_to_currency(outlet.bonus_amount(@bonus1, @quarterTurnover1)  , :unit => "€", :format => "%n %u"),:width => width_a   },
      { :text => number_to_currency(outlet.bonus_amount(@bonus2, @quarterTurnover2)  , :unit => "€", :format => "%n %u"),:width => width_a   },
      { :text => number_to_currency(outlet.bonus_amount(@bonus3, @quarterTurnover3)  , :unit => "€", :format => "%n %u"),:width => width_a   },
      { :text => number_to_currency(outlet.bonus_amount(@bonus4, @quarterTurnover4)  , :unit => "€", :format => "%n %u"),:width => width_a   },
      { :text => number_to_currency(outlet.bonus_amount(@bonus5, @quarterTurnover5)  , :unit => "€", :format => "%n %u"),:width => width_a   },
      { :text => number_to_currency(outlet.bonus_amount(@bonus6, @quarterTurnover6)  , :unit => "€", :format => "%n %u"),:width => width_a } ],

   [ { :text => I18n.t('basket.of_bonus'), :background_color => color_a, :width => width_a  } ,
      { :text => number_to_percentage(@bonus1, :precision => 2),:width => width_a   },
      { :text => number_to_percentage(@bonus2, :precision => 2),:width => width_a   },
      { :text => number_to_percentage(@bonus3, :precision => 2),:width => width_a   },
      { :text => number_to_percentage(@bonus4, :precision => 2),:width => width_a   },
      { :text => number_to_percentage(@bonus5, :precision => 2),:width => width_a   },
      { :text => number_to_percentage(@bonus6, :precision => 2),:width => width_a } ],

   [ { :text => I18n.t('basket.t_category'), :background_color => color_a, :width => width_a  } ,
      { :text => outlet.size(outlet.country_id, @quarterTurnover1).to_s ,:width => width_a   },
      { :text => outlet.size(outlet.country_id, @quarterTurnover2).to_s,:width => width_a   },
      { :text => outlet.size(outlet.country_id, @quarterTurnover3).to_s,:width => width_a   },
      { :text => outlet.size(outlet.country_id, @quarterTurnover4).to_s,:width => width_a   },
      { :text => "",:width => width_a   },
      { :text => "",:width => width_a } ],

   [ { :text => I18n.t('basket.n_turnover'), :background_color => color_a, :width => width_a  } ,
      { :text => number_to_currency(outlet.next_level(outlet.country_id, @quarterTurnover1 ), :unit => "€", :format => "%n %u"), :colspan =>  2, :width => width_b  },
      { :text => number_to_currency(outlet.next_level(outlet.country_id, @quarterTurnover2 ), :unit => "€", :format => "%n %u"), :colspan => 2 ,:width => width_b   },
      { :text => '',:colspan => 2 , :width => width_b   }

   ]
]



pdf.table data, :row_colors => ["E9EBE7","C9CBC8"], :align => :center,:font_size => 8


pdf.move_down(20)

# kpi calculations

@cmp  = outlet.dealer_cmp
@cmpc = outlet.country_cmp(outlet.country_id)
@cmply = @ly_outlet.dealer_cmp

@t = outlet.dealer_target_achievements
@tc = outlet.country_target_achievements(outlet.country_id)
@tly = @ly_outlet.dealer_target_achievements

@a  = outlet.dealer_axs_to_new_car
@ac = outlet.country_axs_to_new_car(outlet.country_id)
@aly  = @ly_outlet.dealer_axs_to_new_car

@cb = outlet.dealer_cmp_body
@cbc = outlet.country_cmp_body(outlet.country_id)
@cbly = @ly_outlet.dealer_cmp_body

@ces  = outlet.dealer_cmp_es
@cesc = outlet.country_cmp_es(outlet.country_id)
@cesly  = @ly_outlet.dealer_cmp_es

@cu  = outlet.dealer_cmp_eu
@cuc = outlet.country_cmp_eu(outlet.country_id)
@culy  = @ly_outlet.dealer_cmp_eu

@tfa  = outlet.dealer_tfa
@tfac = outlet.country_tfa(outlet.country_id)
@tfaly  = @ly_outlet.dealer_tfa

@puo  = outlet.dealer_parts_urgent_orders
@puoc = outlet.country_parts_urgent_orders(outlet.country_id)
@puoly  = @ly_outlet.dealer_parts_urgent_orders

@w = outlet.dealer_windscreen
@wc = outlet.country_windscreen(outlet.country_id)
@w = @ly_outlet.dealer_windscreen

@we  = outlet.dealer_workshop_entries
@wec = outlet.country_workshop_entries(outlet.country_id)
@wely  = @ly_outlet.dealer_workshop_entries

@m = outlet.dealer_motrio
@mc = outlet.country_motrio(outlet.country_id)
@mly = @ly_outlet.dealer_motrio

@la  = outlet.dealer_local_axs_to_new_car
@lac = outlet.country_local_axs_to_new_car(outlet.country_id)
@laly  = @ly_outlet.dealer_local_axs_to_new_car

kpi = [
   [
      {:text => "",:width => width_b,:background_color => color_a },
      {:text => I18n.t('kpi.contract'),     :font_style => :bold, :background_color => color_a, :width => width_a  },
      {:text => I18n.t('kpi.country'),      :font_style => :bold, :background_color => color_a, :width => width_a },
      {:text => I18n.t('kpi.contract_vs_country'),       :font_style => :bold, :background_color =>  color_a, :width => width_a  },
      {:text => I18n.t('kpi.contract_vs_last'),          :font_style => :bold, :background_color => color_a, :width => width_a }
   ],
   [
      {:text => I18n.t('kpi.b_achievement'),:width => width_b },
      {:text => number_to_currency(outlet.bonus_amount(@bonus5, @quarterTurnover5)  , :unit => "€", :format => "%n %u"),     :font_style => :bold, :width => width_a  },
      {:text => '',      :font_style => :bold,       :width => width_a },
      {:text => '',      :font_style => :bold,       :width => width_a  },
      {:text => '',      :font_style => :bold,       :width => width_a }
   ],
   [
      {:text => I18n.t('kpi.cmp'),:width => width_b },
      {:text => number_with_precision(@cmp, :precision => 2),     :font_style => :bold, :width => width_a  },
      {:text => number_with_precision(@cmpc, :precision => 2),:font_style => :bold, :width => width_a },
      {:text => number_with_precision(outlet.cvc(@cmp, @cmpc), :precision => 2),      :font_style => :bold,       :width => width_a  },
      {:text => number_with_precision(outlet.cvcly(@cmp, @cmply), :precision => 2),      :font_style => :bold,       :width => width_a }
   ],
   [
      {:text => I18n.t('kpi.t_achievement'),:width => width_b },
      {:text => number_to_percentage(@t, :precision => 2),     :font_style => :bold, :width => width_a  },
      {:text => number_to_percentage(@tc,:precision => 2),   :font_style => :bold, :width => width_a },
      {:text => number_to_percentage(outlet.cvc(@t, @tc), :precision => 2),      :font_style => :bold,       :width => width_a  },
      {:text => number_with_precision(outlet.cvcly(@t, @tly), :precision => 2),      :font_style => :bold,       :width => width_a }
   ],
   [
      {:text => I18n.t('kpi.axs_to'),:width => width_b },
      {:text => number_with_precision(@a, :precision => 2),     :font_style => :bold, :width => width_a  },
      {:text => number_with_precision(@ac, :precision => 2),   :font_style => :bold, :width => width_a },
      {:text => number_with_precision(outlet.cvc(@a, @ac), :precision => 2),      :font_style => :bold,       :width => width_a  },
      {:text => number_with_precision(outlet.cvcly(@a, @aly), :precision => 2),      :font_style => :bold,       :width => width_a }
   ],
   [
      {:text => I18n.t('kpi.cmp_body'),:width => width_b },
      {:text => number_with_precision(@cb, :precision => 2), :font_style => :bold, :width => width_a  },
      {:text => number_with_precision(@cbc, :precision => 2),   :font_style => :bold, :width => width_a },
      {:text => number_with_precision(outlet.cvc(@cb, @cbc), :precision => 2),      :font_style => :bold,       :width => width_a  },
      {:text => number_with_precision(outlet.cvcly(@cb, @cbly), :precision => 2),      :font_style => :bold,       :width => width_a }
   ],
   [
      {:text => I18n.t('kpi.cmp_es'),:width => width_b },
      {:text => number_with_precision(outlet.dealer_cmp_es, :precision => 2) , :font_style => :bold, :width => width_a  },
      {:text => number_with_precision(outlet.country_cmp_es(outlet.country_id), :precision => 2),   :font_style => :bold, :width => width_a },
      {:text => number_with_precision(outlet.cvc(@ces, @cesc), :precision => 2),      :font_style => :bold,       :width => width_a  },
      {:text => number_with_precision(outlet.cvcly(@ces, @cesly), :precision => 2),      :font_style => :bold,       :width => width_a }
   ],
   [
      {:text => I18n.t('kpi.cmp_eu'),:width => width_b },
      {:text => number_with_precision(@cu, :precision => 2), :font_style => :bold, :width => width_a  },
      {:text => number_with_precision(@cuc, :precision => 2),   :font_style => :bold, :width => width_a },
      {:text => number_with_precision(outlet.cvc(@cu, @cuc), :precision => 2),      :font_style => :bold,       :width => width_a  },
      {:text => number_with_precision(outlet.cvcly(@cu, @culy), :precision => 2),      :font_style => :bold,       :width => width_a }
   ],
   [
      {:text => I18n.t('kpi.tfa'),:width => width_b },
      {:text => number_with_precision(@tfa, :precision => 2), :font_style => :bold, :width => width_a  },
      {:text => number_with_precision(@tfac, :precision => 2),   :font_style => :bold, :width => width_a },
      {:text => number_with_precision(outlet.cvc(@tfa, @tfac), :precision => 2),      :font_style => :bold,       :width => width_a  },
      {:text => number_with_precision(outlet.cvcly(@tfa, @tfaly), :precision => 2),      :font_style => :bold,       :width => width_a }
   ],
   [
      {:text => I18n.t('kpi.p_u_order'),:width => width_b },
      {:text => number_with_precision(@puo, :precision => 2), :font_style => :bold, :width => width_a  },
      {:text => number_with_precision(@puoc, :precision => 2),   :font_style => :bold, :width => width_a },
      {:text => number_with_precision(outlet.cvc(@puo, @puoc), :precision => 2),      :font_style => :bold,       :width => width_a  },
      {:text => number_with_precision(outlet.cvcly(@puo, @puoly), :precision => 2),      :font_style => :bold,       :width => width_a }
   ],
   [
      {:text => I18n.t('kpi.windscreans'),:width => width_b },
      {:text => number_with_precision(@w, :precision => 2 ) , :font_style => :bold, :width => width_a  },
      {:text => number_with_precision(@wc, :precision => 2 ),   :font_style => :bold, :width => width_a },
      {:text => number_with_precision(outlet.cvc(@w, @wc), :precision => 2),      :font_style => :bold,       :width => width_a  },
      {:text => number_with_precision(outlet.cvcly(@w, @wly), :precision => 2),      :font_style => :bold,       :width => width_a }
   ],
   [
      {:text => I18n.t('kpi.w_entries'),:width => width_b },
      {:text => number_with_precision(@we, :precision => 2), :font_style => :bold, :width => width_a  },
      {:text => number_with_precision(@wec, :precision => 2),   :font_style => :bold, :width => width_a },
      {:text => number_with_precision(outlet.cvc(@we, @wec), :precision => 2),      :font_style => :bold,       :width => width_a  },
      {:text => number_with_precision(outlet.cvcly(@we, @wely), :precision => 2),      :font_style => :bold,       :width => width_a }
   ],
   [
      {:text => I18n.t('kpi.t_motrio'),:width => width_b },
      {:text => number_to_percentage(@m, :precision => 2), :font_style => :bold, :width => width_a  },
      {:text => number_to_percentage(@mc, :precision => 2),   :font_style => :bold, :width => width_a },
      {:text => number_to_percentage(outlet.cvc(@m, @mc), :precision => 2),      :font_style => :bold,       :width => width_a  },
      {:text => number_with_precision(outlet.cvcly(@m, @mly), :precision => 2),      :font_style => :bold,       :width => width_a }
   ],
   [
      {:text => I18n.t('kpi.l_axs_to'),:width => width_b },
      {:text => number_with_precision(@la, :precision => 2), :font_style => :bold, :width => width_a  },
      {:text => number_with_precision(@lac, :precision => 2),   :font_style => :bold, :width => width_a },
      {:text => number_with_precision(outlet.cvc(@la, @lac), :precision => 2),      :font_style => :bold,       :width => width_a  },
      {:text => number_with_precision(outlet.cvcly(@la, @laly), :precision => 2),      :font_style => :bold,       :width => width_a }
   ]
]


pdf.table kpi, :row_colors => ["E9EBE7","C9CBC8"], :align => :center,:font_size => 8
pdf.move_down(100)



@retail_tot  = 0
@dealer_net_tot  = 0
@stock_purc_tot = 0

items = outlet.get_monthly_to_follow(Date.today.prev_year).map do |obj|
   @month      = obj.month
   @retail     = obj.retail_to
   @dealer_net = obj.dealer_net_to
   @stock_purc = outlet.stock_purchase(obj)
   @stock      = outlet.stock(@stock_purc, @dealer_net )
   @urgent     = outlet.urgent( @stock )

   @retail_tot      =    @retail_tot + @retail.to_i
   @dealer_net_tot  =    @dealer_net_tot + @dealer_net.to_i
   @stock_purc_tot  =    @stock_purc_tot + @stock_purc.to_i
   @stock_tot      = outlet.stock(@stock_purc_tot, @dealer_net_tot )
   @urgent_tot     = outlet.urgent( @stock_tot )
   [
      { :text => number_with_precision( @month ,:precision => 2 ),      :width => width_a },
      { :text => number_with_precision( @retail , :precision => 2), :width => width_a },
      { :text => number_with_precision( @dealer_net, :precision => 2), :width => width_a },
      { :text => number_with_precision( @stock_purc , :precision => 2), :width => width_a },
      { :text => number_with_precision( @stock , :precision => 2), :width => width_a },
      { :text => number_with_precision( @urgent , :precision => 2), :width => width_a }
   ]


end
total = [[

      { :text => number_with_precision( "TOTAL #{Date.today.prev_year.year}" ,:precision => 2 ), :width => width_a },
      { :text => number_with_precision( @retail_tot , :precision => 2), :width => width_a },
      { :text => number_with_precision( @dealer_net_tot, :precision => 2), :width => width_a },
      { :text => number_with_precision( @stock_purc_tot , :precision => 2), :width => width_a },
      { :text => number_with_precision( @stock_tot , :precision => 2), :width => width_a },
      { :text => number_with_precision( @urgent_tot , :precision => 2), :width => width_a }

   ]]


if !items.empty?

   pdf.table items, :border_style => :grid,
     :row_colors => ["E9EBE7","C9CBC8"],
     :align => :center,:font_size => 8,
     :headers =>  [  { :text => I18n.t('monthly.month'),:font_style => :bold, :width => width_a, :background_color => color_a  },
      { :text => I18n.t('monthly.r_to'),:font_style => :bold, :width => width_a, :background_color => color_a  },
      { :text => I18n.t('monthly.d_n_to'),:font_style => :bold, :width => width_a, :background_color => color_a  },
      { :text => I18n.t('monthly.s_purchase'),:font_style => :bold, :width => width_a, :background_color => color_a  },
      { :text => I18n.t('monthly.stock'),:font_style => :bold, :width => width_a, :background_color => color_a  },
      { :text => I18n.t('monthly.urgent'),:font_style => :bold, :width => width_a, :background_color => color_a  }
   ]


   pdf.table total, :border_style => :grid,
     :row_colors => ["CCFFCC"],
     :align => :center,:font_size => 8

end

pdf.move_down(20)




@retail_tot  = 0
@dealer_net_tot  = 0
@stock_purc_tot = 0

items = outlet.get_monthly_to_follow(Date.today).map do |obj|
   @month      = obj.month
   @retail     = obj.retail_to
   @dealer_net = obj.dealer_net_to
   @stock_purc = outlet.stock_purchase(obj)
   @stock      = outlet.stock(@stock_purc, @dealer_net )
   @urgent     = outlet.urgent( @stock )

   @retail_tot      =    @retail_tot + @retail.to_i
   @dealer_net_tot  =    @dealer_net_tot + @dealer_net.to_i
   @stock_purc_tot  =    @stock_purc_tot + @stock_purc.to_i
   @stock_tot      = outlet.stock(@stock_purc_tot, @dealer_net_tot )
   @urgent_tot     = outlet.urgent( @stock_tot )
   [
      { :text => number_with_precision( @month ,:precision => 2 ),      :width => width_a },
      { :text => number_with_precision( @retail , :precision => 2), :width => width_a },
      { :text => number_with_precision( @dealer_net, :precision => 2), :width => width_a },
      { :text => number_with_precision( @stock_purc , :precision => 2), :width => width_a },
      { :text => number_with_precision( @stock , :precision => 2), :width => width_a },
      { :text => number_with_precision( @urgent , :precision => 2), :width => width_a }
   ]


end
total = [[

      { :text => number_with_precision( "TOTAL #{Date.today.year}" ,:precision => 2 ), :width => width_a },
      { :text => number_with_precision( @retail_tot , :precision => 2), :width => width_a },
      { :text => number_with_precision( @dealer_net_tot, :precision => 2), :width => width_a },
      { :text => number_with_precision( @stock_purc_tot , :precision => 2), :width => width_a },
      { :text => number_with_precision( @stock_tot , :precision => 2), :width => width_a },
      { :text => number_with_precision( @urgent_tot , :precision => 2), :width => width_a }

   ]]


if !items.empty?

   pdf.table items, :border_style => :grid,
     :row_colors => ["E9EBE7","C9CBC8"],
     :align => :center,:font_size => 8,
     :headers =>  [  { :text => I18n.t('monthly.month'),:font_style => :bold, :width => width_a, :background_color => color_a  },
      { :text => I18n.t('monthly.r_to'),:font_style => :bold, :width => width_a, :background_color => color_a  },
      { :text => I18n.t('monthly.d_n_to'),:font_style => :bold, :width => width_a, :background_color => color_a  },
      { :text => I18n.t('monthly.s_purchase'),:font_style => :bold, :width => width_a, :background_color => color_a  },
      { :text => I18n.t('monthly.stock'),:font_style => :bold, :width => width_a, :background_color => color_a  },
      { :text => I18n.t('monthly.urgent'),:font_style => :bold, :width => width_a, :background_color => color_a  }
   ]


   pdf.table total, :border_style => :grid,
     :row_colors => ["CCFFCC"],
     :align => :center,:font_size => 8


end



