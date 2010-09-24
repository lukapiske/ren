class Admin::OutletsController < ApplicationController

   filter_access_to [:read, :edit, :update, :show, :destroy ,:create ]

    
   require 'spreadsheet'
   Spreadsheet.client_encoding = 'UTF-8'

   def index

      @dealers = get_model.just_main
      @country = Admin::Country.all
      @outlets = get_model.paginate :page => params[:page] #, :order => 'created_at DESC'
      #@outlets = get_model.with_permissions_to(:edit)
      #@outlets = get_model.all



      respond_to do |format|
         format.html # index.html.erb
         format.xml  { render :xml => @outlets }
         format.js { render :partial => 'list', :object => [ @dealers, @outlets ] }
      end
   end

   def filter


      conditions = "1=1"
      unless params[:filter_dealer] == "-1"
         conditions += " AND (dealer_group_id  = :filter_dealer)"
      end
      unless params[:filter] == "-1"
         conditions += " AND (outlet_name LIKE  :filter)"
      end
      unless params[:filter_country] == "-1"
         conditions += " AND (country_id = :filter_country)"
      end

      @dealers = get_model.just_main
      @country = Admin::Country.all

      @outlets = get_model.paginate(:page => params[:page] || 1,

         :conditions => [ conditions,
            { :filter => '%' + default_val(params[:filter], '') + '%',
               :filter_dealer => default_val(params[:filter_dealer], ''),
               :filter_country => default_val(params[:filter_country], '')
            }],:order => :dealer_ship_name)



      respond_to do |format|
         format.html
         format.js { render :partial => 'list', :object => [ @dealers, @outlets ] }
         # format.js
      end
   end
   # GET /admin_outlets/1
   # GET /admin_outlets/1.xml
   def show

      @outlet = get_model.find(params[:id])

      respond_to do |format|
         format.html # show.html.erb
         format.xml  { render :xml => @outlet }
      end
   end

   # GET /admin_outlets/new
   # GET /admin_outlets/new.xml
   def new

      @outlet = get_model.new

      respond_to do |format|
         format.html # new.html.erb
         format.xml  { render :xml => @outlet }
      end
   end

   # GET /admin_outlets/1/edit
   def edit
      @outlet = get_model.find(params[:id])
   end

   # POST /admin_outlets
   # POST /admin_outlets.xml
   def create
      @outlet = get_model.new(params[:admin_outlet])


 
      respond_to do |format|
         if @outlet.save
            format.html { redirect_to( @outlet, :notice => 'Admin::Outlet was successfully created.') }
            format.xml  { render :xml => @outlet, :status => :created, :location => @outlet }
         else
            format.html { render :action => "new" }
            format.xml  { render :xml => @outlet.errors, :status => :unprocessable_entity }
         end
      end
   end

   # PUT /admin_outlets/1
   # PUT /admin_outlets/1.xml
   def update
      @outlet = get_model.find(params[:id])

      respond_to do |format|
         if @outlet.update_attributes(params[:admin_outlet])
            format.html { redirect_to(@outlet, :notice => 'Admin::Outlet was successfully updated.') }
            format.xml  { head :ok }
         else
            format.html { render :action => "edit" }
            format.xml  { render :xml => @outlet.errors, :status => :unprocessable_entity }
         end
      end
   end

   # DELETE /admin_outlets/1
   # DELETE /admin_outlets/1.xml
   def destroy
      @outlet = get_model.find(params[:id])
      @outlet.destroy

      respond_to do |format|
         format.html { redirect_to(admin_outlets_url) }
         format.xml  { head :ok }
      end
   end

   def get_outlets_excel

      excelpath = RAILS_ROOT+'/public/assets/outlets/Renault Nordic Network Masterfile.xls'
      #Dealer group number - every dealer could have several outlets .
      #We need id group it. We will add group_id .
      @group_num = 1;
      name = ''
      excel = Spreadsheet.open excelpath
      #Sweden
      swe = excel.worksheet 0
      swe.each do |row|


         @sweden = get_model.new
         next if row[0].nil? || !row[3].is_a?(Integer)
         if name != row[4]
            @group_num += 1
         end
         @sweden.zone                 =   row[0].to_s
         @sweden.dealer_num           =   row[3]
         @sweden.dealer_ship_name     =   row[4]
         @sweden.outlet_name          =   row[7]
         @sweden.address              =   row[14]
         @sweden.zip                  =   row[15]
         @sweden.place                =   row[16]
         @sweden.contract_partner     =   row[17]
         @sweden.main_delivery        =   row[24]
         @sweden.urgent_track         =   row[25]
         @sweden.dealer_group_id      =   @group_num
         @sweden.country              =   'Sweden'
         @sweden.country_id           =   1
         @sweden.save

         name = row[4]

      end
    
      #Denmark
      den = excel.worksheet 1
      den.each do |row|

         @denmark = get_model.new
         next if row[0].nil? || !row[1].is_a?(Integer)
         if name != row[2]
            @group_num += 1
         end
         @denmark.zone                 =   row[0].to_s
         @denmark.dealer_num           =   row[1]
         @denmark.dealer_ship_name     =   row[2]
         @denmark.outlet_name          =   row[5]
         @denmark.address              =   row[12]
         @denmark.zip                  =   row[13]
         @denmark.place                =   row[14]
         @denmark.contract_partner     =   row[15]
         @denmark.main_delivery        =   row[24]
         @denmark.urgent_track         =   row[25]
         @denmark.dealer_group_id      =   @group_num
         @denmark.country              =   'Denmark'
         @denmark.country_id            =   2
         @denmark.save

         name = row[2]
      end
      #Finland
      fin = excel.worksheet 2
      fin.each do |row|

         @finland = get_model.new
         next if row[0].nil? || !row[1].is_a?(Integer)
         if name != row[2]
            @group_num += 1
         end
         @finland.zone                 =   row[0].to_s
         @finland.dealer_num           =   row[1]
         @finland.dealer_ship_name     =   row[2]
         @finland.outlet_name          =   row[5]
         @finland.address              =   row[12]
         @finland.zip                  =   row[13]
         @finland.place                =   row[14]
         @finland.contract_partner     =   row[15]
         @finland.main_delivery        =   row[22]
         @finland.urgent_track         =   row[23]
         @finland.dealer_group_id      =   @group_num
         @finland.country              =   'Finland'
         @finland.country_id            =   3
         @finland.save

         name = row[2]
      end
      #Norway
    
      nor = excel.worksheet 3
      nor.each do |row|
 
         @norway = get_model.new
         next if row[1].nil? || !row[2].is_a?(Integer)
         if name != row[3]
            @group_num += 1
         end
         @norway.zone                 =   row[1].to_s
         @norway.dealer_num           =   row[2]
         @norway.dealer_ship_name     =   row[3]
         @norway.outlet_name          =   row[6]
         @norway.address              =   row[13]
         @norway.zip                  =   row[14]
         @norway.place                =   row[15]
         @norway.contract_partner     =   row[16]
         @norway.main_delivery        =   row[23]
         @norway.urgent_track         =   row[24]
         @norway.dealer_group_id      =   @group_num
         @norway.country              =   'Norway'
         @norway.country_id           =   4
         @norway.save

         name = row[3]
      end
      redirect_to admin_outlets_path
   end
   protected

   def get_model
      Admin::Outlet
   end

   def default_val(param,default='')
      param.nil? || param.to_s.empty? ? default : param
   end
end
