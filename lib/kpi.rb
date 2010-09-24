class Kpi < Outlet


  

  def after_initialize
     @date = Date.today.prev_year
  end


 end
