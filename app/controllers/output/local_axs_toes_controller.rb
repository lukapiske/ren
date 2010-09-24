class Output::LocalAxsToesController < OutputController

 def index
    session[:country_id] = nil
    session[:zone] = nil
    datas
    @outlets
    respond_to do |format|
      format.html
      format.js { render :partial => 'output/local_axs_toes/list', :object => @datas  }
    end
  end
  def ajax_index
    datas
    p session
    respond_to do |format|

      format.js { render :partial => 'output/local_axs_toes/list', :object => @datas  }
    end
  end
  # amcharts load this function
  def bubble
    datas
    @xml = '<chart>' + chart_config + ''
         

    @outlets.each do |data|
      if is_dealer
        @xml << '<point x="' +data.local_axs_to_new_car_x.to_s + '" y="' +data.local_axs_to_new_car_y.to_s + '" value="' +data.local_axs_to_new_car.to_s + '">'+  data.outlet_name.gsub('.', '')+ ' KPI ' + data.local_axs_to_new_car.to_s + '</point>'
      else
        @xml << '<point x="' +data.dealer_local_axs_to_new_car.to_s + '" y="' +data.dealer_local_axs_to_new_car_y.to_s + '" value="' +data.dealer_local_axs_to_new_car.to_s + '">'+  data.dealer_ship_name.gsub('.', '') + ' KPI ' + data.dealer_local_axs_to_new_car.to_s + '</point>'
      end
    end
    @xml << '</graph>
       </graphs>
   </chart>'

    render :xml => @xml
  end

  private

  def datas
    if params[:local_axs_toes]

      if params[:local_axs_toes][:country_id].nil?
        session[:country_id] = current_user.country_id
      else
        session[:country_id] = params[:local_axs_toes][:country_id]
      end

      if params[:admin_user].nil?
        session[:zone] = params[:local_axs_toes][:zone]
      else
        session[:zone] = params[:admin_user][:zone]
      end

    end
    if session[:country_id]
     if is_dealer
        @outlets = Admin::Outlet.zone(session[:zone]).dealers(session[:country_id]).just_main.sort_by { |obj| -obj.cmp_body.to_f }
      else
        @outlets = Admin::Outlet.zone(session[:zone]).dealers(session[:country_id]).just_main.sort_by { |obj| -obj.dealer_cmp_body.to_f }
      end
    else
      if is_dealer
        @outlets = get_datas.sort_by { |obj| -obj.cmp_body.to_f }
      else
        @outlets = get_datas.sort_by { |obj| -obj.cmp_body.to_f }
      end
    end
  end

end
