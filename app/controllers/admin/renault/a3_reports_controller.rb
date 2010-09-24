class Admin::Renault::A3ReportsController < ApplicationController

  require 'spreadsheet'
  Spreadsheet.client_encoding = 'UTF-8'
  # GET /admin_renault_a3_reports
  # GET /admin_renault_a3_reports.xml
  def index
    @a3_reports = get_model.paginate :page => params[:page], :order => 'created_at DESC'
   
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admin_renault_a3_reports }
    end
  end

  # GET /admin_renault_a3_reports/1
  # GET /admin_renault_a3_reports/1.xml
  #  def show
  #    @a3_report = Admin::Renault::A3Report.find(params[:id])
  #
  #    respond_to do |format|
  #      format.html # show.html.erb
  #      format.xml  { render :xml => @a3_report }
  #    end
  #  end
  def show
    redirect_to admin_renault_a3_reports_path
  end

  # GET /admin_renault_a3_reports/new
  # GET /admin_renault_a3_reports/new.xml
  def new
    @a3_report = Admin::Renault::A3Report.new
    @countries = get_countries.all
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @a3_report }
    end
  end

  # GET /admin_renault_a3_reports/1/edit
  def edit
    @a3_report = Admin::Renault::A3Report.find(params[:id])
  end

  # POST /admin_renault_a3_reports
  # POST /admin_renault_a3_reports.xml
  def create

    @report = get_model.new(params[:admin_renault_a3_report])
    @report.user_id = current_user

    respond_to do |format|
      if @report.save
        #read excel and add it to the database
        read_excel(@report.excelfiles.path, @report.id)

        format.html { redirect_to(@report, :notice => 'Excel was successfully saved.') }
        format.xml  { render :xml => @report, :status => :created, :location => @report }

      else


        format.js { redirect_to admin_renault_a3_reports_path, :notice => @report.errors.full_messages }

      end
    end
  end

  # PUT /admin_renault_a3_reports/1
  # PUT /admin_renault_a3_reports/1.xml
  def update
    @a3_report = Admin::Renault::A3Report.find(params[:id])

    respond_to do |format|
      if @a3_report.update_attributes(params[:a3_report])
        format.html { redirect_to(@a3_report, :notice => 'Admin::Renault::A3Report was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @a3_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_renault_a3_reports/1
  # DELETE /admin_renault_a3_reports/1.xml
  def destroy
    @a3_report = Admin::Renault::A3Report.find(params[:id])
    @a3_report.destroy

    respond_to do |format|
      format.html { redirect_to(admin_renault_a3_reports_url) }
      format.xml  { head :ok }
    end
  end

  private

  def get_model
    Admin::Renault::A3Report
  end
  def get_countries
    Admin::Country
  end

  def read_excel(excelPath , id)

    excel  = Spreadsheet.open excelPath
    sheet  = excel.worksheet 0
    sheet1 = excel.worksheet 1

    arr1 =  sheet.to_a
    arr2 =  sheet1.to_a
    i = 0
    arr1.each do |row|
      
      report = get_model.find(id)
      @report_data = report.a3reports_datas.new
    
       if arr1[i][1].to_s != ''

        @report_data.outlets_id         = arr1[i][0]
        @report_data.name               = arr1[i][1]
        @report_data.contact_total      = arr1[i][2]
        @report_data.contact_total_ly   = arr1[i][3]
        @report_data.visit_total        = arr2[i][2]
        @report_data.visit_total_ly     = arr2[i][3]
        @report_data.date_for           = report.date
        @report_data.bir                = report.country_code.to_s + arr1[i][0].to_s

        @report_data.save
      end
      i += 1

    end


  end
end
