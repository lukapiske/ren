# Methods added to this helper will be available to all templates in the application.
module OutputHelper
  def is_dealer
    current_user.role_id == 3
  end

  def is_zonemanager
    current_user.role_id == 4
  end

  def getConfig

    return   "../../amcharts/amxy.swf", "amxy", "100%", "400px", "8", "#FFFFFF"
   end
end
