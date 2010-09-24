{
  :'en' => {
    :date => {
      :formats => {
        :long_ordinal => lambda { |date| "%B #{date.day.ordinalize}, %Y" }
      }
    },
    :time => {
      :formats => {
        :long_ordinal => lambda { |time| "%B #{time.day.ordinalize}, %Y %H:%M" }
      },
      :time_with_zone => {
        :formats => {
          :default => lambda { |time| "%Y-%m-%d %H:%M:%S #{time.formatted_offset(false, 'UTC')}" }
        }
      },
      :am => 'am',
      :pm => 'pm'
    },
    # date helper distance in words
    #NOTE: Pluralization rules have changed! Rather than simply submitting an array, i18n now allows for a hash with the keys:
    # :zero, :one & :other   - FUNKY (but a pain to find...)!
    :datetime => {
      :distance_in_words => {
        :half_a_minute       => 'half a minute',
        :less_than_x_seconds => {:zero => 'less than 1 second', :one => '1 second', :other => '{{count}} seconds'},
        :x_seconds           => {:one => '1 second', :other => '{{count}} seconds'},
        :less_than_x_minutes => {:zero => 'less than a minute', :one => '1 minute', :other => '{{count}} minutes'},
        :x_minutes           => {:one => "1 minute", :other => "{{count}} minutes"},
        :about_x_hours       => {:one => 'about 1 hour', :other => '{{count}} hours'},
        :x_days              => {:one => '1 day', :other => '{{count}} days'},
        :about_x_months      => {:one => 'about 1 month', :other => '{{count}} months'},
        :x_months            => {:one => '1 month', :other => '{{count}} months'},
        :about_x_years       => {:one => 'about 1 year', :other => '{{count}} years'},
        :over_x_years        => {:one => 'over 1 year', :other => '{{count}} years'}
      }
    },

    # numbers
    :number => {
      :format => {
        :precision => 3,
        :separator => ',',
        :delimiter => '.'
      },
      :currency => {
        :format => {
          :unit => '$',
          :precision => 2,
          :format => '%u %n'
        }
      }
    },
    :info => {
      :no_data => 'Data missing'
    },

    :menu => {
      :invoices => "Invoice",
      :bonus_targets => "Bonus target",
      :car_sales => "Car sales",
      :car_parks => "Car parks",
      :a3_reports => "A3 report",
      :outlets => "Outlets",
      :users => "Users",
      :right_side => {
        :axs_to_newcars => "AXS TO New car",
        :cmp => "CMP",
        :cmp_bodies => "CMP BODY",
        :cmp_es => "CMP E/S",
        :cmp_eu => "CMP E/U"
      }

    },
    :excel_output => {
       :excel_title => "Contract factsheets",
       :bir_no => "BIR NO",
       :dealer_name => "DEALER NAME",
       :country => "COUNTRY",
       :zone => "ZONE",
       :zone_manager => "ZONE MANAGER",
       :sigmpr => "SIGMPR",

    },
    :basket => {
       :o_parts => "ORIGINAL PARTS(OE)",
       :accessories => "ACCESSORIES(AM)",
       :total => "TOTAL(OE + AM)",
       :q_turnover => "Quarter TURNOVER",
       :q_target   => "Quarter TARGET",
       :b_amount => "Bonus amount",
       :of_bonus => "% of bonus",
       :achievement => "ACHIEVEMENT",
       :t_category => "Turnover CATEGORY",
       :n_turnover => "Next Turnover Level",
       :achived => "ACHIVED",
       :projection => "PROJECTION"
    },
    :kpi => {
       :b_achievement => 'Bonus achievement',
       :cmp => "CMP",
       :t_achievement => "Target achievement",
       :axs_to   =>  "AXS to new car",
       :cmp_body =>  "CMP BODY",
       :cmp_es   =>  "CMP E/S",
       :cmp_eu   =>  "CMP E/U",
       :tfa      =>  "TFA",
       :p_u_order => "Parts urgent order",
       :windscreans => "Windscreans",
       :w_entries   => "Workshop entries",
       :t_motrio    => "To motrio / TO E/U",
       :l_axs_to    => "Local AXS TO",
       :contract => "Contract",
       :country  => "Country",
       :contract_vs_country => "Contract vs. Country",
       :kpi => "KPI",
       :contract_vs_last   => "Contract #{Date.today.year} vs. #{Date.today.prev_year.year}"
    },

    :monthly => {
       :month => 'MONTH',
       :r_to => 'Retailt TO',
       :retail_to => 'Retailt TO',
       :d_n_to => "Dealer net TO",
       :s_purchase => "Stock purchase",
       :stock    => "%stock",
       :urgent => "urgent",
       :total => "TOTAL"
    },
    :wear => {
      :month => 'MONTH',
      :q_total => 'QUARTER TOTAL',
      :total => 'TOTAL'
    },
    :forms => {
       :country => 'Country',
       :zone => 'ZONE'

    }
  }
}