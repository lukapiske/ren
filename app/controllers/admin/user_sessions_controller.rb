class Admin::UserSessionsController < ApplicationController
  def new
    @user_session = get_model.new
  end
  
  def create
    @user_session = get_model.new(params[:admin_user_session])
    if @user_session.save
      flash[:notice] = "Logged in successfully."
      redirect_to_target_or_default( admin_renault_main_index_path )
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @user_session = get_model.find
    @user_session.destroy
    flash[:notice] = "You have been logged out."
    redirect_to root_url
  end
  private
  def get_model
    Admin::UserSession
  end
end
