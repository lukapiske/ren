class Admin::Renault::CarSalesController < ApplicationController

  require 'spreadsheet'
  Spreadsheet.client_encoding = 'UTF-8'
  # GET /admin_renault_car_sales
  # GET /admin_renault_car_sales.xml
  def index
    @car_sales = get_model.paginate :page => params[:page], :order => 'created_at DESC'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admin_renault_car_sales }
    end
  end

  # GET /admin_renault_car_sales/1
  # GET /admin_renault_car_sales/1.xml
  #  def show
  #    @car_sale = Admin::Renault::CarSale.find(params[:id])
  #
  #    respond_to do |format|
  #      format.html # show.html.erb
  #      format.xml  { render :xml => @car_sale }
  #    end
  #  end
  def show
    redirect_to admin_renault_car_sales_path
  end
  # GET /admin_renault_car_sales/new
  # GET /admin_renault_car_sales/new.xml
  def new
    @car_sale = Admin::Renault::CarSale.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @car_sale }
    end
  end

  # GET /admin_renault_car_sales/1/edit
  def edit
    @car_sale = Admin::Renault::CarSale.find(params[:id])
  end

  # POST /admin_renault_car_sales
  # POST /admin_renault_car_sales.xml
  def create

    @sales = get_model.new(params[:admin_renault_car_sale])
    @sales.user_id = current_user

    respond_to do |format|
      if @sales.save
        #read excel and add it to the database
        read_excel(@sales.excelfiles.path, @sales.id)

        format.html { redirect_to(@sales, :notice => 'Excel was successfully saved.') }
        format.xml  { render :xml => @sales, :status => :created, :location => @sales }

      else

        
        format.js { redirect_to admin_renault_car_sales_path, :notice => @sales.errors.full_messages }

      end
    end
  end

  # PUT /admin_renault_car_sales/1
  # PUT /admin_renault_car_sales/1.xml
  def update
    @car_sale = Admin::Renault::CarSale.find(params[:id])

    respond_to do |format|
      if @car_sale.update_attributes(params[:car_sale])
        format.html { redirect_to(@car_sale, :notice => 'Admin::Renault::CarSale was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @car_sale.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_renault_car_sales/1
  # DELETE /admin_renault_car_sales/1.xml
  def destroy
    @car_sale = Admin::Renault::CarSale.find(params[:id])
    @car_sale.destroy

    respond_to do |format|
      format.html { redirect_to(admin_renault_car_sales_url) }
      format.xml  { head :ok }
    end
  end
  private
  def read_excel(excelPath , id)

    excel = Spreadsheet.open excelPath
    sheet = excel.worksheet 0
    sheet_dachia = excel.worksheet 1
    sheet.each do |row|

      sales = get_model.find(id)
   
      @sales_data = sales.csales_datas.new
      next if row[0].nil?
      date = row[1] + ''+sales.date.year.to_s

      @sales_data.code           =  row[0]
      @sales_data.date           =  date.to_time
      @sales_data.acronym        =  row[2]
      @sales_data.bir            =  replace_letter(row[0])
      @sales_data.date_for       =  sales.date
      @sales_data.model          =  'renault'
      @sales_data.time_stamp     =  date.to_time.to_i

      @sales_data.save

    end
    sheet_dachia.each do |row|

      sales = get_model.find(id)
      date = row[1] + ''+sales.date.year.to_s
      @sales_data = sales.csales_datas.new
      next if row[0].nil?
      

      @sales_data.code           =  row[0]
      @sales_data.date           =  date.to_time
      @sales_data.acronym        =  row[2]
      @sales_data.bir            =  '208' + row[0].to_s
      @sales_data.date_for       =  sales.date
      @sales_data.model          =  'dacia'
      @sales_data.time_stamp     =  date.to_time.to_i

      @sales_data.save
    end

  end

  def get_model
    Admin::Renault::CarSale
  end
  def replace_letter(str)
    str.to_s
    letter = str[0,1]

    case letter
    when 'S' then
      newstr = str.gsub('S','752')
      return newstr
    when 'D' then
      newstr =  str.gsub('D','208')
      return newstr
    when 'F' then
      newstr = str.gsub('F','246')
      return newstr
    when 'N' then
      newstr = str.gsub('N','278')
      return newstr
    else
      return 'greska'
    end


  end
end
