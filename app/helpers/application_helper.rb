# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
 
   def mainmenu(name)
      controller.class.controller_name == name ? 'menu-active' : ''
   end
   def submenu(name)
      controller.class.controller_name == name ? 'open' : ''
   end


 
 
end
