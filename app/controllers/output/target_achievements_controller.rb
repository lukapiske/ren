class Output::TargetAchievementsController < OutputController

   #before_filter :datas

   def index
      session[:country_id] = nil
      session[:zone] = nil
      datas
      
      respond_to do |format|
         format.html
         format.js { render :partial => 'output/target_achievements/list', :object => @datas  }
      end
   end
   def ajax_index
      datas
      respond_to do |format|

         format.js { render :partial => 'output/target_achievements/list', :object => @datas  }
      end
   end
   # amcharts load this function
   def bubble
      datas
      @xml = '<chart>' + chart_config + ''
          \
      @outlets.each do |data|
         if is_dealer
            @xml << '<point x="' +data.target_achievements_x.to_s + '" y="' +data.target_achievements_y.to_s + '" value="' +data.target_achievements.to_s + '">'+  data.outlet_name.gsub('.', '')+ ' KPI ' + data.target_achievements.to_s + '</point>'
         else
            @xml << '<point x="' +data.dealer_target_achievements_x.to_s + '" y="' +data.dealer_target_achievements_y.to_s + '" value="' +data.dealer_target_achievements.to_s + '">'+  data.dealer_ship_name.gsub('.', '') + ' KPI ' + data.dealer_target_achievements.to_s + '</point>'
         end
      end
      @xml << '</graph>
       </graphs>
   </chart>'

      render :xml => @xml
   end

   private

   def datas
      if params[:target_achievements]

         if params[:target_achievements][:country_id].nil?
            session[:country_id] = current_user.country_id
         else
            session[:country_id] = params[:target_achievements][:country_id]
         end

         if params[:admin_user].nil?
            session[:zone] = params[:target_achievements][:zone]
         else
            session[:zone] = params[:admin_user][:zone]
         end

      end
      if session[:country_id]
         if is_dealer
            @outlets = Admin::Outlet.zone(session[:zone]).dealers(session[:country_id]).just_main.sort_by { |obj| -obj.target_achievements.to_f }
         else
            @outlets = Admin::Outlet.zone(session[:zone]).dealers(session[:country_id]).just_main.sort_by { |obj| -obj.dealer_target_achievements.to_f }
         end
      else
         if is_dealer
            @outlets = get_datas.sort_by { |obj| -obj.target_achievements.to_f }
         else
            @outlets = get_datas.sort_by { |obj| -obj.dealer_target_achievements.to_f }
         end
      end
   end
end
