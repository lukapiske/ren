class Output::WorkshopsFrequentationsController < OutputController

  def index
    session[:country_id] = nil
    session[:zone] = nil
    datas
    @outlets
    respond_to do |format|
      format.html
      format.js { render :partial => 'output/workshops_frequentations/list', :object => @datas  }
    end
  end
  def ajax_index
    datas
    respond_to do |format|

      format.js { render :partial => 'output/workshops_frequentations/list', :object => @datas  }
    end
  end
  # amcharts load this function
  def bubble
    datas
    @xml = '<chart>' + chart_config + ''
              
    @outlets.each do |data|
      if is_dealer
        @xml << '<point x="' +data.tfa_x.to_s + '" y="' +data.tfa_y.to_s + '" value="' +data.tfa.to_s + '">'+  data.outlet_name.gsub('.', '')+ ' KPI ' + data.tfa.to_s + '</point>'
      else
        @xml << '<point x="' +data.dealer_tfa_x.to_s + '" y="' +data.dealer_tfa_y.to_s + '" value="' +data.dealer_tfa.to_s + '">'+  data.dealer_ship_name.gsub('.', '') + ' KPI ' + data.dealer_tfa.to_s + '</point>'
      end
    end
    @xml << '</graph>
       </graphs>
   </chart>'

    render :xml => @xml
  end

  private

  def datas
    if params[:workshops_frequentations]

      if params[:workshops_frequentations][:country_id].nil?
        session[:country_id] = current_user.country_id
      else
        session[:country_id] = params[:workshops_frequentations][:country_id]
      end

      if params[:admin_user].nil?
        session[:zone] = params[:workshops_frequentations][:zone]
      else
        session[:zone] = params[:admin_user][:zone]
      end

    end
     if session[:country_id]
     if is_dealer
        @outlets = Admin::Outlet.zone(session[:zone]).dealers(session[:country_id]).just_main.sort_by { |obj| -obj.tfa.to_f }
      else
        @outlets = Admin::Outlet.zone(session[:zone]).dealers(session[:country_id]).just_main.sort_by { |obj| -obj.dealer_tfa.to_f }
      end
    else
      if is_dealer
        @outlets = get_datas.sort_by { |obj| -obj.tfa.to_f }
      else
        @outlets = get_datas.sort_by { |obj| -obj.dealer_tfa.to_f }
      end
    end
  end


end
