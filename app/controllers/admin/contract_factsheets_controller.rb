class Admin::ContractFactsheetsController < ApplicationController


   filter_access_to :all

   def index
  
   end
   def show

      #@outlet = get_model.with_permissions_to(:read, :context => :outlet).find(params[:id])
      diff =  0
      unless params[:diff].nil?
         diff = params[:diff].to_i
      end

      unless params[:date_for].nil?
         y = params[:date_for][:year]
         m = params[:date_for][:month]
         d = params[:date_for][:day]

         date1 = Date.new( y.to_i, m.to_i , d.to_i)
         date2 = Date.today
         diff =  date2 - date1
      end
  
      

      a  = get_model.find(params[:id])
      a.date = Date.today - diff
      @outlet = a
      @diff = diff
      #@datas = Admin::Factsheet.find(params[:id])
      #Kpi class extends Outlet class, and set date to last year
      # b instance will be for last year
      b  = get_model.find(params[:id])
      b.date = Date.today - 12.month - diff
      @ly_outlet = b
      #@ly_outlet = Kpi.find(params[:id])
      respond_to do  |format|
         format.html
         format.js { render :partial => "show", :object => [ @outlet, @ly_outlet ]}
         format.pdf
      end
   end

   #   def excel_output
   #
   #      @datas = Admin::Factsheet.find(params[:id])
   #
   #
   #      book = Spreadsheet::Workbook.new
   #      sheet1 = book.create_worksheet
   #
   #      sheet1.name = I18n.t('excel_output.excel_title')
   #
   #
   #      sheet1[0,2] = I18n.t('excel_output.bir_no')
   #      sheet1[0,3] = I18n.t('excel_output.dealer_name')
   #      sheet1[0,4] = I18n.t('excel_output.country')
   #      sheet1[0,5] = I18n.t('excel_output.zone')
   #      sheet1[0,6] = I18n.t('excel_output.zone_manager')
   #      sheet1[0,7] = I18n.t('excel_output.sigmpr')
   #
   #      z = @datas.zone_manager(@datas.zone, @datas.country_id)
   #
   #      zonemanager =   z.name +  ' ' + z.surname
   #
   #      sheet1[1,2] = @datas.dealer_num
   #      sheet1[1,3] = @datas.dealer_ship_name
   #      sheet1[1,4] = @datas.country
   #      sheet1[1,5] = @datas.zone
   #      sheet1[1,6] = zonemanager
   #      sheet1[1,7] = @datas.main_delivery
   #
   #
   #      sheet1.row(0).height = 40
   #
   #
   #
   #
   #      #
   #      #
   #      #
   #      #      i = 0
   #      #      @datas.each do |excel|
   #      #         i = i + 1
   #      #         sheet1[i,0] = excel.dealer_num
   #      #         sheet1[i,1] = excel.country
   #      #         sheet1[i,2] = excel.zone
   #      #         sheet1[i,3] = excel.dealer_ship_name
   #      #         sheet1[i,4] = excel.dealer_axs_to_new_car
   #      #         sheet1[i,5] = excel.dealer_axs_to_new_car_x
   #      #         sheet1[i,6] = excel.dealer_axs_to_new_car_y
   #      #
   #      #      end
   #      #
   #      #      #    sheet1[1,0] = 'Japan'
   #      #      #    row = sheet1.row(1)
   #      #      #    row.push 'Creator of Ruby'
   #      #      #    row.unshift 'Yukihiro Matsumoto'
   #      #      #    sheet1.row(2).replace [ 'Daniel J. Berger', 'U.S.A.',
   #      #      #      'Author of original code for Spreadsheet::Excel' ]
   #      #      #    sheet1.row(3).push 'Charles Lowe', 'Author of the ruby-ole Library'
   #      #      #    sheet1.row(3).insert 1, 'Unknown'
   #      #      #    sheet1.update_row 4, 'Hannes Wyss', 'Switzerland', 'Author'
   #      #      #    sheet1.row(0).height = 14
   #      #      #
   #      format = Spreadsheet::Format.new :color => :blue,
   #
   #        :weight => :bold,
   #        :size => 10
   #
   #      sheet1.row(0).default_format = format
   #      #      #
   #      #      bold = Spreadsheet::Format.new :weight => :bold, :color => :red
   #      #      num.times do |x| sheet1.row(x + 1).set_format(4, bold) end
   #      #
   #      book.write "/home/software/manager/public/excel_outputs/#{Date.today}-contract_factsheets.xls"
   #      #
   #      #      @files = Dir.glob("public/excel_outputs/*.xls")
   #
   #      render :text => 'hello'
   #   end

   private

   def get_model
      Admin::Factsheet

   end


end

