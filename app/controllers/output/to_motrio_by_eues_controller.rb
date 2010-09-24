class Output::ToMotrioByEuesController < OutputController


  def index
    session[:country_id] = nil
    session[:zone] = nil
    datas
    @outlets
    respond_to do |format|
      format.html
      format.js { render :partial => 'output/to_motrio_by_eues/list', :object => @datas  }
    end
  end
  def ajax_index
    datas
    p session
    respond_to do |format|

      format.js { render :partial => 'output/to_motrio_by_eues/list', :object => @datas  }
    end
  end
  # amcharts load this function
  def bubble
    datas
    @xml = '<chart>' + chart_config + ''
        
    @outlets.each do |data|
      if is_dealer
        @xml << '<point x="' +data.motrio.to_s + '" y="' +data.motrio_y.to_s + '" value="' +data.motrio.to_s + '">'+  data.outlet_name.gsub('.', '')+ ' KPI ' + data.motrio.to_s + '</point>'
      else
        @xml << '<point x="' +data.dealer_motrio_x.to_s + '" y="' +data.dealer_motrio_y.to_s + '" value="' +data.dealer_motrio.to_s + '">'+  data.dealer_ship_name.gsub('.', '') + ' KPI ' + data.dealer_motrio.to_s + '</point>'
      end
    end
    @xml << '</graph>
       </graphs>
   </chart>'

    render :xml => @xml
  end

  private

  def datas
    if params[:to_motrio_by_eues]

      if params[:to_motrio_by_eues][:country_id].nil?
        session[:country_id] = current_user.country_id
      else
        session[:country_id] = params[:to_motrio_by_eues][:country_id]
      end

      if params[:admin_user].nil?
        session[:zone] = params[:to_motrio_by_eues][:zone]
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
