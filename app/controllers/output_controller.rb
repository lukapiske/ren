class OutputController < ApplicationController


   filter_access_to :all

   def get_datas


      if is_dealer
         @outlets = get_outlet.with_permissions_to(:read, :context => :outlet)
      else
         @outlets = get_outlet.just_main.with_permissions_to(:read, :context => :outlet)
  
      end
   end
   #just graph using this function
   def is_dealer
      current_user.role_id == 3 #dealer role == 3 7 doesn't exist
   end

   def chart_config

      @xml ='<graphs>
                <graph gid="0" min_max="false" color="#000000" fill_color="#00CC00" fill_alpha="20">
  
             </graph>
             <!-- this graph draws green rectangle -->
               <graph gid="0" min_max="false" color="#000000" fill_color="#99cc33" fill_alpha="20">

               </graph>
               <!-- this graph draws red rectangle -->
               <graph gid="0" min_max="false" color="#000000" fill_color="#CC0000" fill_alpha="20">

    </graph>
    <graph gid="0" min_max="false" color="#000000" fill_color="#336699" fill_alpha="20">

    </graph>

      <graph gid="0" alpha="10"  balloon_text="{description}"  bullet="bubble" color="F9C700">
                <data_labels>{value}</data_labels>'

   end

 

   private
   def get_outlet
      Admin::Outlet
   end



end