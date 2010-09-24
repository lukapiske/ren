class HomeController < ApplicationController

  filter_access_to :all
  def index
    redirect_to admin_login_path
  end
  def show
   
  end
end
