class Admin::Renault::Scaffold::BonusController < ApplicationController
  filter_access_to :all
  layout "scaff"
  active_scaffold "admin/renault/bonusData" do |config|
    config.columns = [ :bir, :name, :target_q3_oe, :target_q3_am, :date]
    config.actions.exclude :show, :create, :search
    config.update.link.inline = false
  end


  def conditions_for_collection
    @conditions = { :bonus_target_id => params[:object]}
  end


end
