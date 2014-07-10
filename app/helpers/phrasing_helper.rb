module PhrasingHelper
  # You must implement the can_edit_phrases? method.
  # Example:
  #
  # def can_edit_phrases?
  #  current_user.is_admin?
  # end

  def can_edit_phrases?
     if user_signed_in?
              if controller_name == "static_pages"              
                            if current_page?(:controller => 'static_pages',:action => 'cafe')
                              current_user.moderator?(:cafe)
                                                          
                            elsif current_page?(:controller => 'static_pages',:action => 'fos')
                              current_user.moderator?(:fos)
                            
                            elsif current_page?(:controller => 'static_pages',:action => 'kulturministerie')
                              current_user.moderator?(:km)
                            
                            elsif current_page?(:controller => 'static_pages',:action => 'naringslivsutskott')
                              current_user.moderator?(:fnu)
                            
                            elsif current_page?(:controller => 'static_pages',:action => 'prylmasteri')
                              current_user.moderator?(:pryl)
                            
                            elsif current_page?(:controller => 'static_pages',:action => 'sanningsministerie')
                              current_user.moderator?(:sanning)
                            
                            elsif current_page?(:controller => 'static_pages',:action => 'sexmasteri')
                              current_user.moderator?(:sexmasteri)
                            
                            elsif current_page?(:controller => 'static_pages',:action => 'studierad')
                              current_user.moderator?(:studierad)
                            
                            elsif current_page?(:controller => 'static_pages',:action => 'styrelse')
                              current_user.moderator?(:styrelse)
                            
                            elsif current_page?(:controller => 'static_pages',:action => 'utskott')
                              current_user.moderator?(:utskott)
                            
                            elsif current_page?(:controller => 'static_pages',:action => 'om')
                              current_user.moderator?(:sanning)
                            
                            elsif current_page?(:controller => 'static_pages',:action => 'faq')
                              current_user.moderator?(:faq)
                              
                            elsif current_page?(:controller => 'static_pages',:action => 'kontakt')
                              current_user.moderator?(:kontakt)
                            end
                            elsif current_page?(:controller => 'static_pages', :action => 'index')
                              current_user.moderator?(:startsida)
                            end                                          
                  elsif controller_name == "phrasing_phrases"
                    true
                  end
    else
     false
     end
  end
end
