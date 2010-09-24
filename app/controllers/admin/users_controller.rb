class Admin::UsersController < ApplicationController

   filter_access_to :all
   #before_filter :authenticate , :except => [:get_dealers, :get_zones]


   def index
      @users = get_model.paginate :page => params[:page]
      @countries = get_countries.all
      @roles = get_roles.all
      respond_to do |format|
         format.html
         format.js { render :partial => 'list', :object => [ @roles, @users ] }
      end
   end

   def new

      @user = get_model.new
      @countries = get_countries.all
      @roles = get_roles.all

      respond_to do |format|
         format.html
         format.js { render :partial => 'form', :object => @user }

      end

   end
   def edit
      @user =  get_model.find(params[:id])
      session[:edited_user] = @user
      session[:country] = @user.country_id
      @countries = get_countries.all
      @roles = get_roles.all
      @outlets = get_outlets.zones(@user.country_id)
      @dealers = get_outlets.dealers_by_zone(@user.country_id, @user.zone)
    
      respond_to do |format|
         format.html
         format.js { render :partial => 'form', :object => @user }
      end
   end
   def update
      @user = get_model.find(params[:id])
      @countries = get_countries.all
      @roles = get_roles.all
      @outlets = get_outlets.zones(@user.country_id)
      @dealers = get_outlets.dealers(@user.country_id)
    
      respond_to do |format|
         if @user.update_attributes(params[:admin_user])
            format.html { redirect_to(admin_users_path, :notice => 'User was successfully updated.') }
            format.xml  { head :ok }
         else
            format.html { render :action => "edit"}
            format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
         end
      end
   end
   def create
      @user = get_model.new(params[:admin_user])
      @countries = get_countries.all
      @roles = get_roles.all
      @users = get_model.all
      respond_to do |format|
         if @user.save
       
            flash[:notice] = "Thank you for signing up! You are now logged in."
            format.html { redirect_to(admin_users_path, :notice => 'User was successfully created.') }
         else
            format.html { render :action => "new" }
         end
      end
   end
   def destroy
      @user = get_model.find(params[:id])
      @user.destroy

      respond_to do |format|
         format.html { redirect_to(admin_users_url) }
         format.xml  { head :ok }
      end
   end
   def filter


      conditions = "1=1"
      unless params[:filter_role] == "-1"
         conditions += " AND (role_id  = :filter_role)"
      end
      unless params[:filter].empty?
         conditions += " AND ( name LIKE  :filter OR surname LIKE :filter)"
      end
      unless params[:filter_country] == "-1"
         conditions += " AND (country_id = :filter_country)"
      end

     
      @role = Admin::Role.all
      @country = Admin::Country.all

      @users = get_model.paginate(:page => params[:page] || 1,

         :conditions => [ conditions,
            { :filter => '%' + default_val(params[:filter], '') + '%',
               :filter_role => default_val(params[:filter_role], ''),
               :filter_country => default_val(params[:filter_country], '')
            }],:order => :name)



      respond_to do |format|
         format.html
         format.js { render :partial => 'list', :object => [ @role, @users ] }
         # format.js
      end
   end
   def get_dealers

      if(session[:country].nil?)
         session[:country] = session[:edited_user].country_id
      end
      @dealers = get_outlets.main_dealers(session[:country], params[:zone])
        
      respond_to do |format|
         format.js { render :partial => 'country_select', :object => @dealers }
      end
   end
   def get_zones
    
      session[:country] = params[:country_id]

      @zones = get_outlets.zones(params[:country_id])
      respond_to do |format|
         format.js { render :partial => 'zone_select', :object => @zones }
      end
   end

   private
 
   def get_model
      Admin::User
   end
   def get_countries
      Admin::Country
   end
   def get_outlets
      Admin::Outlet
   end
   def get_roles
      Admin::Role
   end
   def default_val(param,default='')
      param.nil? || param.to_s.empty? ? default : param
   end
end
