module PhrasingHelper
  def can_edit_phrases?    
    if controller_name == "phrasing_phrases"        
        true     
    elsif user_signed_in?      
      if (controller.controller_name == 'static_pages') && (controller.action_name == 'kontakt')  #current_page? funkar inte för en POST-request!
        current_user.moderator?(:kontakt)
      elsif controller_name == "councils" && params[:id]
        @council = Council.find_by_url(params[:id])                                  
                if  @council
                  current_user.moderator?(@council.url)
                end
      elsif controller_name == "static_pages"        
        if current_page?(:controller => 'static_pages',:action => 'utskott')
          current_user.moderator?(:utskott)                            
        elsif current_page?(:controller => 'static_pages',:action => 'om')
          current_user.moderator?(:sanning)                            
        elsif current_page?(:controller => 'static_pages', :action => 'index')
          current_user.moderator?(:startsida)
        end
      end
   else
     false
   end
  end
end
