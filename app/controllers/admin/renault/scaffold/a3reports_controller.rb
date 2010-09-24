class Admin::Renault::Scaffold::A3reportsController < ApplicationController
  #filter_access_to :all
  layout "scaff"
  active_scaffold "admin/renault/a3reportsData" do |config|
    config.columns = [ :name, :contact_total, :contact_total_ly, :visit_total, :visit_total_ly,:date_for]
    config.actions.exclude :show, :create, :search
    config.update.link.inline = false
  end


  def conditions_for_collection
    @conditions = { :a3_report_id => params[:object]}
  end
end
