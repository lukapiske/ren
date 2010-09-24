class Output::PartsUrgentOrdersController < OutputController


  def index
    session[:country_id] = nil
    session[:zone] = nil
    datas
    @outlets
    respond_to do |format|
      format.html
      format.js { render :partial => 'output/parts_urgent_orders/list', :object => @datas  }
    end
  end
  def ajax_index
    datas
    respond_to do |format|

      format.js { render :partial => 'output/parts_urgent_orders/list', :object => @datas  }
    end
  end
  # amcharts load this function
  def bubble
    datas
    @xml = '<chart>' + chart_config + ''
   \
    @outlets.each do |data|
      if is_dealer
        @xml << '<point x="' +data.parts_urgent_orders_x.to_s + '" y="' +data.parts_urgent_orders_y.to_s + '" value="' +data.parts_urgent_orders.to_s + '">'+  data.outlet_name.gsub('.', '')+ ' KPI ' + data.parts_urgent_orders.to_s + '</point>'
      else
        @xml << '<point x="' +data.dealer_parts_urgent_orders_x.to_s + '" y="' +data.dealer_parts_urgent_orders_y.to_s + '" value="' +data.dealer_parts_urgent_orders.to_s + '">'+  data.dealer_ship_name.gsub('.', '') + ' KPI ' + data.dealer_parts_urgent_orders.to_s + '</point>'
      end
    end
    @xml << '</graph>
       </graphs>
   </chart>'

    render :xml => @xml
  end

  private

  def datas
    if params[:parts_urgent_orders]

      if params[:parts_urgent_orders][:country_id].nil?
        session[:country_id] = current_user.country_id
      else
        session[:country_id] = params[:parts_urgent_orders][:country_id]
      end

      if params[:admin_user].nil?
        session[:zone] = params[:parts_urgent_orders][:zone]
      else
        session[:zone] = params[:admin_user][:zone]
      end

    end
     if session[:country_id]
     if is_dealer
        @outlets = Admin::Outlet.zone(session[:zone]).dealers(session[:country_id]).just_main.sort_by { |obj| -obj.parts_urgent_orders.to_f }
      else
        @outlets = Admin::Outlet.zone(session[:zone]).dealers(session[:country_id]).just_main.sort_by { |obj| -obj.dealer_parts_urgent_orders.to_f }
      end
    else
      if is_dealer
        @outlets = get_datas.sort_by { |obj| -obj.parts_urgent_orders.to_f }
      else
        @outlets = get_datas.sort_by { |obj| -obj.dealer_parts_urgent_orders.to_f }
      end
    end
  end
end