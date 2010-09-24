class Admin::Renault::BonusTargetsController < ApplicationController

  require 'spreadsheet'
  Spreadsheet.client_encoding = 'UTF-8'
  # GET /admin_renault_bonus_targets
  # GET /admin_renault_bonus_targets.xml
  def index

    @bonus = get_model.paginate :page => params[:page], :order => 'created_at DESC'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admin_renault_bonus_targets }
    end
  end

  # GET /admin_renault_bonus_targets/1
  # GET /admin_renault_bonus_targets/1.xml
  #  def show
  #    @bonus_target = Admin::Renault::BonusTarget.find(params[:id])
  #
  #    respond_to do |format|
  #      format.html # show.html.erb
  #      format.xml  { render :xml => @bonus_target }
  #    end
  #  end
  def show
    redirect_to admin_renault_bonus_targets_path
  end

  # GET /admin_renault_bonus_targets/new
  # GET /admin_renault_bonus_targets/new.xml
  def new
    @bonus_target = Admin::Renault::BonusTarget.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bonus_target }
    end
  end

  # GET /admin_renault_bonus_targets/1/edit
  #  def edit
  #    @bonus_target = Admin::Renault::BonusTarget.find(params[:id])
  #  end

  # POST /admin_renault_bonus_targets
  # POST /admin_renault_bonus_targets.xml
  def create

    @bonus = get_model.new(params[:admin_renault_bonus_target])
    @bonus.user_id = current_user
  
    respond_to do |format|
      if @bonus.save
        #read excel and add it to the database
        read_excel(@bonus.excelfiles.path, @bonus.id)

        format.html { redirect_to(@bonus, :notice => 'Excel was successfully saved.') }
        format.xml  { render :xml => @bonus, :status => :created, :location => @bonus }

      else


        format.js { redirect_to admin_renault_bonus_targets_path, :notice => @bonus.errors.full_messages }

      end
    end
  end

  # PUT /admin_renault_bonus_targets/1
  # PUT /admin_renault_bonus_targets/1.xml
  #  def update
  #    @bonus_target = Admin::Renault::BonusTarget.find(params[:id])
  #
  #    respond_to do |format|
  #      if @bonus_target.update_attributes(params[:bonus_target])
  #        format.html { redirect_to(@bonus_target, :notice => 'Admin::Renault::BonusTarget was successfully updated.') }
  #        format.xml  { head :ok }
  #      else
  #        format.html { render :action => "edit" }
  #        format.xml  { render :xml => @bonus_target.errors, :status => :unprocessable_entity }
  #      end
  #    end
  #  end

  # DELETE /admin_renault_bonus_targets/1
  # DELETE /admin_renault_bonus_targets/1.xml
  def destroy
    @bonus_target = Admin::Renault::BonusTarget.find(params[:id])
    @bonus_target.destroy

    respond_to do |format|
      format.html { redirect_to(admin_renault_bonus_targets_url) }
      format.xml  { head :ok }
    end
  end

  private
  def read_excel(excelPath , id)

    excel = Spreadsheet.open excelPath
    sheet1 = excel.worksheet 0
    sheet1.each do |row|

      bonus = get_model.find(id)
      @bonus_data = bonus.bonus_datas.new
      next if !row[0].is_a?(Integer)

      @bonus_data.bir           =  row[0]
      @bonus_data.name          =  row[1]
      @bonus_data.target_q3_oe  =  row[2]
      @bonus_data.target_q3_am  =  row[3]
      @bonus_data.date          =  bonus.date

      @bonus_data.save
    end

  end


  def get_model
    Admin::Renault::BonusTarget
  end
end
