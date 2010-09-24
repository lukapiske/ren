class Admin::Renault::Scaffold::CarparksController < ApplicationController
  filter_access_to :all
  layout "scaff"
  active_scaffold "admin/renault/carparkData" do |config|
    config.columns = [:dealer_number, :number_of_car, :date_for]
    config.actions.exclude :show, :create, :search
    config.update.link.inline = false
  end


  def conditions_for_collection
    @conditions = { :car_park_id => params[:object]}
  end
end
