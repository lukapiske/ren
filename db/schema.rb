# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100916150601) do

  create_table "admin_countries", :force => true do |t|
    t.string   "name"
    t.integer  "code",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_factsheets", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_outlets", :force => true do |t|
    t.string   "zone",             :limit => 5
    t.integer  "dealer_num"
    t.string   "dealer_ship_name"
    t.string   "outlet_name"
    t.string   "address"
    t.string   "zip"
    t.string   "place"
    t.string   "contract_partner", :limit => 11
    t.integer  "main_delivery"
    t.integer  "urgent_track"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dealer_group_id",                :null => false
    t.string   "country",          :limit => 20, :null => false
    t.integer  "country_id",                     :null => false
  end

  create_table "admin_renault_a3_reports", :force => true do |t|
    t.string   "excelfiles_file_name"
    t.string   "excelfiles_content_type"
    t.string   "excelfiles_file_size"
    t.string   "excelfiles_updated_at"
    t.integer  "user_id"
    t.integer  "country_code",            :null => false
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_renault_a3reports_datas", :force => true do |t|
    t.integer  "outlets_id"
    t.string   "name"
    t.integer  "contact_total"
    t.integer  "contact_total_ly"
    t.integer  "visit_total"
    t.integer  "visit_total_ly"
    t.date     "date_for"
    t.integer  "bir"
    t.integer  "a3_report_id",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_renault_a3reports_datas", ["bir"], :name => "index_admin_renault_a3reports_datas_on_bir"

  create_table "admin_renault_bonus_datas", :force => true do |t|
    t.integer  "bir"
    t.string   "name"
    t.float    "target_q3_oe"
    t.float    "target_q3_am"
    t.date     "date"
    t.integer  "bonus_target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_renault_bonus_datas", ["bonus_target_id"], :name => "index_admin_renault_bonus_datas_on_bonus_target_id"

  create_table "admin_renault_bonus_targets", :force => true do |t|
    t.string   "excelfiles_file_name"
    t.string   "excelfiles_content_type"
    t.string   "excelfiles_file_size"
    t.string   "excelfiles_updated_at"
    t.integer  "user_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_renault_car_parks", :force => true do |t|
    t.string   "excelfiles_file_name"
    t.string   "excelfiles_content_type"
    t.string   "excelfiles_file_size"
    t.string   "excelfiles_updated_at"
    t.integer  "user_id"
    t.date     "datum"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_renault_car_sales", :force => true do |t|
    t.string   "excelfiles_file_name"
    t.string   "excelfiles_content_type"
    t.string   "excelfiles_file_size"
    t.string   "excelfiles_updated_at"
    t.integer  "user_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_renault_carpark_datas", :force => true do |t|
    t.integer  "dealer_number"
    t.integer  "number_of_car"
    t.date     "date_for"
    t.integer  "car_park_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_renault_carpark_datas", ["dealer_number"], :name => "index_admin_renault_carpark_datas_on_dealer_number"

  create_table "admin_renault_carsales_datas", :force => true do |t|
    t.string   "code"
    t.date     "date"
    t.string   "acronym"
    t.date     "date_for",                  :null => false
    t.integer  "car_sale_id"
    t.integer  "bir"
    t.string   "model",       :limit => 20, :null => false
    t.integer  "time_stamp",                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_renault_invoice_datas", :force => true do |t|
    t.integer  "CODFIL"
    t.integer  "NROCTEDESS"
    t.string   "CODSEG"
    t.integer  "CODFAM"
    t.integer  "CODFAC"
    t.integer  "sumOfPNCTOT",      :limit => 10, :precision => 10, :scale => 0
    t.integer  "sumOfPCLTOT",      :limit => 10, :precision => 10, :scale => 0
    t.integer  "sumOfTEFAC",       :limit => 10, :precision => 10, :scale => 0
    t.integer  "is_deleted"
    t.integer  "invoice_excel_id"
    t.date     "DATCRE"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "CODCON"
  end

  add_index "admin_renault_invoice_datas", ["CODFIL"], :name => "index_admin_renault_invoice_datas_on_CODFIL"
  add_index "admin_renault_invoice_datas", ["DATCRE"], :name => "index_admin_renault_invoice_datas_on_DATCRE"
  add_index "admin_renault_invoice_datas", ["NROCTEDESS"], :name => "index_admin_renault_invoice_datas_on_NROCTEDESS"
  add_index "admin_renault_invoice_datas", ["invoice_excel_id"], :name => "index_admin_renault_invoice_datas_on_invoice_excel_id"

  create_table "admin_renault_invoice_excels", :force => true do |t|
    t.string   "excelfiles_file_name"
    t.string   "excelfiles_content_type"
    t.string   "excelfiles_file_size"
    t.string   "excelfiles_updated_at"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "persistence_token"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.integer  "country_id",                     :null => false
    t.integer  "dealer_group_id",                :null => false
    t.integer  "role_id",                        :null => false
    t.string   "zone",              :limit => 5, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                           :null => false
    t.string   "surname",                        :null => false
    t.string   "tel"
  end

  create_table "dealer_bonus", :force => true do |t|
    t.integer  "country_id"
    t.integer  "dealer_size", :null => false
    t.float    "size_one"
    t.float    "size_two"
    t.float    "size_three"
    t.float    "size_four"
    t.float    "size_five"
    t.float    "size_max"
    t.date     "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dealer_sizes", :force => true do |t|
    t.integer  "country_id"
    t.integer  "dealer_size",   :null => false
    t.integer  "q1"
    t.integer  "q2"
    t.integer  "q3"
    t.integer  "q4"
    t.integer  "all_year_from", :null => false
    t.integer  "all_year_to",   :null => false
    t.date     "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
