ActionController::Routing::Routes.draw do |map|

  map.resources :home
  map.root :home
  
  map.namespace(:output) do |output|
    output.resources :target_achievements, :singular => 'target_achievement',:collection => { :bubble => :get, :ajax_index => :get }
    output.resources :axs_to_newcars, :singular => 'axs_to_newcar' ,:collection => { :bubble => :get, :ajax_index => :get, :export_as_image => :get, :export => :get }
    output.resources :wholesales, :singular => 'wholesale',:collection => { :bubble => :get, :ajax_index => :get }
    output.resources :windscreens, :singular => 'windscreen',:collection => { :bubble => :get, :ajax_index => :get }
    output.resources :parts_urgent_orders, :singular => 'parts_urgent_order',:collection => { :bubble => :get, :ajax_index => :get }
    output.resources :cmp_bodies, :singular => 'cmp_body',:collection => { :bubble => :get, :ajax_index => :get }
    output.resources :cmp_es, :singular => 'cmp_e', :collection => { :bubble => :get, :ajax_index => :get }
    output.resources :cmp_eues, :singular => 'cmp_eu',:collection => { :bubble => :get, :ajax_index => :get }
    output.resources :workshops_frequentations, :singular => 'workshops_frequentation' , :collection => { :bubble => :get, :ajax_index => :get }
    output.resources :service_contract_penetrations, :singular => 'service_contract_penetration' ,:collection => { :bubble => :get, :ajax_index => :get }
    output.resources :workshop_entries, :singular => 'workshop_entry',:collection => { :bubble => :get, :ajax_index => :get }
    output.resources :local_axs_toes, :singular => 'local_axs_to',:collection => { :bubble => :get, :ajax_index => :get }
    output.resources :cmp_cmpes, :singular => 'cmp_cmp',:collection => { :bubble => :get, :ajax_index => :get }
    output.resources :to_motrio_by_eues, :singular => 'to_motrio_by_eu',:collection => { :bubble => :get, :ajax_index => :get }
    output.resources :tires_mounting_rates, :singular => 'tires_mounting_rate',:collection => { :bubble => :get, :ajax_index => :get }
    output.resources :tires, :singular => 'tire',:collection => { :bubble => :get, :ajax_index => :get }
    
  end

  map.namespace(:admin) do |admin|

    admin.resources :role_manager, :active_scaffold => true
    admin.signup 'signup', :controller => 'users', :action => 'new'
    admin.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
    admin.login 'login', :controller => 'user_sessions', :action => 'new'
    admin.resources :user_sessions
    admin.resources :users, :collection => { :get_dealers => :post, :get_zones => :post, :filter => :get  }
    admin.resources :outlets, :collection => { :get_outlets_excel => :get, :filter => :get }
    admin.resources :contract_factsheets, :singular => 'contract_factsheet', :member => { :excel_output => :get  }
    admin.namespace(:renault) do |renault|

      renault.resources :main
      renault.resources :excels , :singular => "excel"

      renault.resources :invoice_excels , :singular => "invoice_excel"
      renault.resources :bonus_targets,  :singular => "bonus_target"
      renault.resources :car_sales,  :singular => "car_sale"
      renault.resources :car_parks, :singular => "car_park"
      renault.resources :a3_reports, :singular => "a3_report"
      #renault.resources  :invoice_excels ,:active_scaffold => true, :collection => { :datas => :get }
      renault.resources  :invoice_datas ,:active_scaffold => true
      


      renault.namespace(:scaffold) do |scaffold|
        scaffold.resources  :invoices ,:active_scaffold => true
        scaffold.resources  :bonus ,:active_scaffold => true
        scaffold.resources  :carsales ,:active_scaffold => true
        scaffold.resources  :carparks ,:active_scaffold => true
        scaffold.resources  :a3reports ,:active_scaffold => true
      end
    end

  end

  


end
