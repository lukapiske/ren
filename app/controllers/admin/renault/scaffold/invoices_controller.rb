class Admin::Renault::Scaffold::InvoicesController < ApplicationController
  filter_access_to :all
  layout "scaff"
  active_scaffold "admin/renault/invoiceData" do |config|
    config.columns = [ :CODFIL, :NROCTEDESS, :CODSEG, :CODFAM, :CODFAC,:sumOfPNCTOT, :sumOfPCLTOT,:sumOfTEFAC, :DATCRE]
    config.actions.exclude :show, :create, :search
    config.update.link.inline = false
    config.columns[:sumOfPNCTOT].calculate = :sum
    config.columns[:sumOfPCLTOT].calculate = :sum
    config.columns[:sumOfTEFAC].calculate = :sum
    config.list.per_page = 15
   
    
  


    #config.columns[:CODFIL].set_link 'edit', :position => :replace
    #config.theme = :blue

  
  end
  private
  def conditions_for_collection
    @conditions = { :invoice_excel_id => params[:object]}
  end
 
end



