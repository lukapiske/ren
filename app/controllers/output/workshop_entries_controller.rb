class Output::WorkshopEntriesController < OutputController

  def index
    session[:country_id] = nil
    session[:zone] = nil
    datas
    @outlets
    respond_to do |format|
      format.html
      format.js { render :partial => 'output/workshop_entries/list', :object => @datas  }
    end
  end
  def ajax_index
    datas
    respond_to do |format|

      format.js { render :partial => 'output/workshop_entries/list', :object => @datas  }
    end
  end
  # amcharts load this function
  def bubble
    datas
    @xml = '<chart>' + chart_config + ''
              
    @outlets.each do |data|
      if is_dealer
        @xml << '<point x="' +data.workshop_entries_x.to_s + '" y="' +data.workshop_entries_y.to_s + '" value="' +data.workshop_entries.to_s + '">'+  data.outlet_name.gsub('.', '')+ ' KPI ' + data.workshop_entries.to_s + '</point>'
      else
        @xml << '<point x="' +data.dealer_workshop_entries_x.to_s + '" y="' +data.dealer_workshop_entries_y.to_s + '" value="' +data.dealer_workshop_entries.to_s + '">'+  data.dealer_ship_name.gsub('.', '') + ' KPI ' + data.dealer_workshop_entries.to_s + '</point>'
      end
    end
    @xml << '</graph>
       </graphs>
   </chart>'

    render :xml => @xml
  end

  private

  def datas
    if params[:workshop_entries]

      if params[:workshop_entries][:country_id].nil?
        session[:country_id] = current_user.country_id
      else
        session[:country_id] = params[:workshop_entries][:country_id]
      end

      if params[:admin_user].nil?
        session[:zone] = params[:workshop_entries][:zone]
      else
        session[:zone] = params[:admin_user][:zone]
      end

    end
     if session[:country_id]
     if is_dealer
        @outlets = Admin::Outlet.zone(session[:zone]).dealers(session[:country_id]).just_main.sort_by { |obj| -obj.workshop_entries.to_f }
      else
        @outlets = Admin::Outlet.zone(session[:zone]).dealers(session[:country_id]).just_main.sort_by { |obj| -obj.dealer_workshop_entries.to_f }
      end
    else
      if is_dealer
        @outlets = get_datas.sort_by { |obj| -obj.workshop_entries.to_f }
      else
        @outlets = get_datas.sort_by { |obj| -obj.dealer_workshop_entries.to_f }
      end
    end
  end
end
