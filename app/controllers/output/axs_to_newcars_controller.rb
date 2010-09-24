class Output::AxsToNewcarsController < OutputController

   require 'spreadsheet'
   Spreadsheet.client_encoding = 'UTF-8'


   def index
      session[:country_id] = nil
      session[:zone] = nil
      datas
      @outlets
      respond_to do |format|
         format.html
         format.js { render :partial => 'output/axs_to_newcars/list', :object => @datas  }
      
      end
   end
   def ajax_index
      datas
      respond_to do |format|
    
         format.js { render :partial => 'output/axs_to_newcars/list', :object => @datas  }
      end
   end
   # amcharts load this function
   def bubble
      datas
      @xml = '<chart>' + chart_config + ''

      @outlets.each do |data|
         if is_dealer
            @xml << '<point x="' +data.axs_to_new_car_x.to_s + '" y="' +data.axs_to_new_car_y.to_s + '" value="' +data.axs_to_new_car.to_s + '">'+  data.outlet_name.gsub('.', '')+ ' KPI ' + data.axs_to_new_car.to_s + '</point>'
         else
            @xml << '<point data_labels="{description}" x="' +data.dealer_axs_to_new_car_x.to_s + '" y="' +data.dealer_axs_to_new_car_y.to_s + '" value="' +data.dealer_axs_to_new_car.to_s + '">'+  data.dealer_ship_name.gsub('.', '') + ' KPI ' + data.dealer_axs_to_new_car.to_s + '</point>'
         end
      end
      @xml << '</graph>
       </graphs>
   </chart>'

      render :xml => @xml
   end
   def export

      @datas = datas
      num = @datas.count
      book = Spreadsheet::Workbook.new
      sheet1 = book.create_worksheet
   
      sheet1.name = 'AXS TO new car'
    
      #sheet1.row(0).concat %w{Dealer_num  	Country  	Zone  	Dealer_ship_name  	KPI_Dealer_Axs_TO/New_car  	Dealer_X_axes  	Dealer_Y_axes}
      
      sheet1[0,0] = "Dealer Num"
      sheet1[0,1] = "Country"
      sheet1[0,2] = "Zone"
      sheet1[0,3] = "Dealer ship name"
      sheet1[0,4] = "KPI"
      sheet1[0,5] = "X"
      sheet1[0,6] = "Y"


      i = 0
      @datas.each do |excel|
         i = i + 1
         sheet1[i,0] = excel.dealer_num
         sheet1[i,1] = excel.country
         sheet1[i,2] = excel.zone
         sheet1[i,3] = excel.dealer_ship_name
         sheet1[i,4] = excel.dealer_axs_to_new_car
         sheet1[i,5] = excel.dealer_axs_to_new_car_x
         sheet1[i,6] = excel.dealer_axs_to_new_car_y

      end

      #    sheet1[1,0] = 'Japan'
      #    row = sheet1.row(1)
      #    row.push 'Creator of Ruby'
      #    row.unshift 'Yukihiro Matsumoto'
      #    sheet1.row(2).replace [ 'Daniel J. Berger', 'U.S.A.',
      #      'Author of original code for Spreadsheet::Excel' ]
      #    sheet1.row(3).push 'Charles Lowe', 'Author of the ruby-ole Library'
      #    sheet1.row(3).insert 1, 'Unknown'
      #    sheet1.update_row 4, 'Hannes Wyss', 'Switzerland', 'Author'
      #    sheet1.row(0).height = 14
      #
      format = Spreadsheet::Format.new :color => :blue,
        :weight => :bold,
        :size => 12
      sheet1.row(0).default_format = format
      #
      bold = Spreadsheet::Format.new :weight => :bold, :color => :red
      num.times do |x| sheet1.row(x + 1).set_format(4, bold) end

      book.write "/home/software/manager/public/excel_outputs/#{Date.today}-axs_to_new_car.xls"

      #@files = Dir.glob("public/excel_outputs/*.xls")
    
   end

   def export_as_image
    
      width = params[:width].to_i
      height = params[:height].to_i
      data = {}
      img = Magick::Image.new(width, height)
      height.times do |y|
         row = params["r#{y}"].split(',')
         row.size.times do |r|
            pixel = row[r].to_s.split(':')
            pixel[0] = pixel[0].to_s.rjust(6, '0')
            if pixel.size == 2
               pixel[1].to_i.times do
                  (data[y] ||= []) << pixel[0]
               end
            else
               (data[y] ||= []) << pixel[0]
            end
         end
         width.times do |x|
            img.pixel_color(x, y, "##{data[y][x]}")
         end
      end
      img.format = "PNG"
      send_data(img.to_blob , :disposition => 'inline', :type => 'image/png', :filename => "chart.png?#{rand(99999999).to_i}")
   end


   private

   def datas
      if params[:axs_to_new_car]
      
         if params[:axs_to_new_car][:country_id].nil?
            session[:country_id] = current_user.country_id
         else
            session[:country_id] = params[:axs_to_new_car][:country_id]
         end
          
         if params[:admin_user].nil?
            session[:zone] = params[:axs_to_new_car][:zone]
         else
            session[:zone] = params[:admin_user][:zone]
         end
   
      end
      if session[:country_id]
         if is_dealer
            @outlets = Admin::Outlet.zone(session[:zone]).dealers(session[:country_id]).just_main.sort_by { |obj| -obj.axs_to_new_car.to_f }
         else
            @outlets = Admin::Outlet.zone(session[:zone]).dealers(session[:country_id]).just_main.sort_by { |obj| -obj.dealer_axs_to_new_car.to_f }
         end
      else
         if is_dealer
            @outlets = get_datas.sort_by { |obj| -obj.axs_to_new_car.to_f }
         else
            @outlets = get_datas.sort_by { |obj| -obj.dealer_axs_to_new_car.to_f }
         end
      end
   end
end
