class Admin::Renault::CarParksController < ApplicationController
  
  
  require 'spreadsheet'
  Spreadsheet.client_encoding = 'UTF-8'
  def index
    @car_parks = get_model.paginate :page => params[:page], :order => 'created_at DESC'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @car_parks }
    end
  end

  # GET /admin_renault_car_parks/1
  # GET /admin_renault_car_parks/1.xml
  #  def show
  #    @car_park = Admin::Renault::CarPark.find(params[:id])
  #
  #    respond_to do |format|
  #      format.html # show.html.erb
  #      format.xml  { render :xml => @car_park }
  #    end
  #  end
  def show
    redirect_to admin_renault_car_parks_path
  end
  # GET /admin_renault_car_parks/new
  # GET /admin_renault_car_parks/new.xml
  def new
    @car_park = Admin::Renault::CarPark.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @car_park }
    end
  end

  # GET /admin_renault_car_parks/1/edit
  def edit
    @car_park = Admin::Renault::CarPark.find(params[:id])
  end

  # POST /admin_renault_car_parks
  # POST /admin_renault_car_parks.xml
  def create

    @parks = get_model.new(params[:admin_renault_car_park])
    @parks.user_id = current_user

    respond_to do |format|
      if @parks.save
        #read excel and add it to the database
        read_excel(@parks.excelfiles.path, @parks.id)

        format.html { redirect_to(@parks, :notice => 'Excel was successfully saved.') }
        format.xml  { render :xml => @parks, :status => :created, :location => @parks }

      else


        format.js { redirect_to admin_renault_car_parks_path, :notice => @parks.errors.full_messages }

      end
    end
  end

  # PUT /admin_renault_car_parks/1
  # PUT /admin_renault_car_parks/1.xml
  def update
    @car_park = Admin::Renault::CarPark.find(params[:id])

    respond_to do |format|
      if @car_park.update_attributes(params[:car_park])
        format.html { redirect_to(@car_park, :notice => 'Admin::Renault::CarPark was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @car_park.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_renault_car_parks/1
  # DELETE /admin_renault_car_parks/1.xml
  def destroy
    @car_park = Admin::Renault::CarPark.find(params[:id])
    @car_park.destroy

    respond_to do |format|
      format.html { redirect_to(admin_renault_car_parks_url) }
      format.xml  { head :ok }
    end
  end
  private
  def read_excel(excelPath , id)

    excel = Spreadsheet.open excelPath
    sheet = excel.worksheet 0
    sheet.each do |row|

      parks = get_model.find(id)
      @parks_data = parks.carpark_datas.new
      dn = row[1].to_i.round
      next if row[1].nil? || (dn == 0)

      @parks_data.dealer_number = row[0]
      @parks_data.number_of_car = row[1].to_i.round
      @parks_data.date_for = parks.datum

      @parks_data.save
      
    end

  end


  def get_model
    Admin::Renault::CarPark
  end
end
