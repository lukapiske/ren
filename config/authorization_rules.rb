authorization do

  role :admin do
    includes :dealer
    has_permission_on [
      :admin_renault_scaffold_a3reports,
      :admin_renault_scaffold_bonus,
      :admin_renault_scaffold_carparks,
      :admin_renault_scaffold_carsales,
      :admin_renault_scaffold_invoices,
      :admin_outlets,
      :admin_users,
      :admin_renault_excels,
      :admin_renault_invoice_excels,
      :admin_renault_bonus_targets,
      :admin_renault_car_sales ,
      :admin_renault_car_parks,
      :admin_renault_a3_reports
    
      
    ], :to => :manage

    has_permission_on :outlet, :to => [:read, :edit ,:update, :show, :filter] do
      if_attribute  :zone	=> is { user.zone 	 }
    end
    
  end
  

  role :zonemanager do
    includes :dealer
    has_permission_on :outlet, :to => [:read, :edit ,:update, :show] do
      if_attribute  :zone 	=> is { user.zone 	 }
    end
  end

  role :hubmanager do
    includes :dealer
    has_permission_on :outlet, :to => [:read, :edit ,:update, :show] do
      if_attribute  :country_id 	=> is { user.country_id 	 }
    end

  end

  role :dealer do
    #    has_permission_on :admin_renault_invoice_excels, :to => :manage
    #    has_permission_on :admin_renault_scaffold_invoices, :to => :scaffolds
    #    has_permission_on :admin_renault_car_sales, :to => :manage
    #    has_permission_on :admin_renault_scaffold_carsales, :to => :scaffolds
    #    has_permission_on :admin_renault_car_parks, :to => :manage
    #    has_permission_on :admin_renault_scaffold_carparks, :to => :scaffolds
    has_permission_on [
      :output_target_achievements,
      :output_axs_to_newcars,
      :output_wholesales,
      :output_windscreens,
      :output_parts_urgent_orders,
      :output_cmp_bodies,
      :output_cmp_es,
      :output_cmp_eues,
      :output_workshops_frequentations,
      :output_service_contract_penetrations,
      :output_workshop_entries,
      :output_local_axs_toes,
      :output_cmp_cmpes,
      :output_to_motrio_by_eues,
      :output_tires_mounting_rates,
      :output_tires,
      :admin_contract_factsheets
      
    ], :to => [ :read, :bubble,:ajax_index,:export_as_image, :export , :set_locale, :show ]


    has_permission_on :outlet, :to => [ :edit ,:update, :show, :read  ] do
      if_attribute  :dealer_group_id 	=> is { user.dealer_group_id 	 }
    end
  end

  role :guest do
    #      has_permission_on :outlet, :to => [:index, :show]
    #      has_permission_on :comments, :to => [:new, :create]
    #      # user can manage only own comments
    #      has_permission_on :comments, :to => [:edit, :update] do
    #        if_attribute :user => is { user }
    #      end
  end

end

privileges do
  privilege :manage do
    includes :read,:index, :show, :new, :create, :edit, :update, :destroy,:get_zones, :get_dealers, :bubble, :choose, :ajax_index, :export_as_image, :set_locale, :filter
  end
  privilege :scaffolds do
    includes :read,:index, :show, :new, :create, :edit, :update, :destroy, :delete, :row, :set_locale
  end
  privilege :read do
    includes :read, :index
  end
end
