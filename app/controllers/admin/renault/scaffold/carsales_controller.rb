class Admin::Renault::Scaffold::CarsalesController < ApplicationController
  filter_access_to :all
  layout "scaff"
  active_scaffold "admin/renault/csalesData" do |config|
    config.columns = [:code, :date, :acronym, :model ]
    config.actions.exclude :show, :create, :search
    config.update.link.inline = false
  end


  def conditions_for_collection
    @conditions = { :car_sale_id => params[:object]}
  end
end
