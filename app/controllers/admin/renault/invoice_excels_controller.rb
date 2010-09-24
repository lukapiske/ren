class Admin::Renault::InvoiceExcelsController < ApplicationController

  filter_access_to :all
  require 'spreadsheet'
  Spreadsheet.client_encoding = 'UTF-8'

  def index

    @excel = get_model.paginate :page => params[:page], :order => 'created_at DESC'
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @excel }
    end
  end

  #  def show
  #
  #    @excel_data = get_model_data.paginate :page => params[:page], :order => 'id ASC',
  #      :conditions => ['invoice_excel_id = ?', "#{params[:id]}"]
  #
  #    respond_to do |format|
  #      format.html # show.html.erb
  #      format.xml  { render :xml => @excel_data }
  #    end
  #  end
  def show
    redirect_to admin_renault_invoice_excels_path
  end

  def new

    @excel = get_model.new
    respond_to do |format|
      format.html
      format.js { render :partial => 'form', :object => @excel }

    end
  end


  #  def edit
  #    @excel = get_model.find(params[:id])
  #  end


  def create

    @excel = get_model.new(params[:admin_renault_invoice_excel])
    @excel.user_id = current_user
    respond_to do |format|
        if @excel.save
        #read excel and add it to the database
        read_excel(@excel.excelfiles.path, @excel.id)

        format.html { redirect_to(@excel, :notice => 'Excel was successfully saved.') }
        format.xml  { render :xml => @excel, :status => :created, :location => @excel }

      else


        format.js { redirect_to admin_renault_invoice_excels_path, :notice => @excel.errors.full_messages }

      end
    end
  end


  def update
    @excel = get_model.find(params[:id])

    respond_to do |format|
      if @excel.update_attributes(params[:admin_renault_invoice_excel])
        format.html { redirect_to(@excel, :notice => 'Example was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @excel.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @excel = get_model.find(params[:id])
    @excel.destroy

    respond_to do |format|
      format.html { redirect_to(admin_renault_invoice_excels_url) }
      format.xml  { head :ok }
    end
  end


  def datas

    redirect_to :controller => 'admin/renault/scaffold/invoices',  :action => 'index', :object => params[:id]

  end

  private

  def read_excel(excelPath , id)

    excel = Spreadsheet.open excelPath
    sheet1 = excel.worksheet 0
    sheet1.each do |row|

      @excel_data = get_model.find(id).invoice_datas.new
      next if row[0].nil? && !row[1].is_a?(Integer)

        negativearray = [23,26]
        @negative = 1
        if negativearray.include? row[4].to_i
          @negative = -1
        end

      @excel_data.CODFIL       =   row[0]
      @excel_data.NROCTEDESS   =   row[1]
      @excel_data.CODSEG       =   row[2]
      @excel_data.CODFAM       =   row[3]
      @excel_data.CODFAC       =   row[4]
      @excel_data.sumOfPNCTOT  =   (row[5].to_i * @negative)
      @excel_data.sumOfPCLTOT  =   (row[6].to_i * @negative)
      @excel_data.sumOfTEFAC   =   (row[7].to_i * @negative)
      @excel_data.DATCRE       =   row[8]
      @excel_data.CODCON       =   row[9]

        @excel_data.save
     
    end
       
  end


  def get_model
    Admin::Renault::InvoiceExcel
  end

  def get_model_data
    Admin::Renault::InvoiceData
  end

end
