
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base


  include Authentication

  helper :all
  protect_from_forgery
 
  before_filter { |c| Authorization.current_user = c.current_user }



  before_filter :set_locale

   def set_locale
    # update session if passed
    session[:locale] = params[:locale] if params[:locale]

    # set locale based on session or default
    I18n.locale = session[:locale] || I18n.default_locale
  end

 
  protected
  
  def permission_denied
    flash[:error] = "Sorry, you are not allowed to access that page."
    redirect_to new_admin_user_session_url
  end

  def authenticate
    authenticate_or_request_with_http_basic do |name, pass|
      #User.authenticate(name, pass)
      name == 'superadmin' && pass == 'superadmin'
    end
  end



end
