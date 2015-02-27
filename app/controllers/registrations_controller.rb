# encoding:UTF-8
class RegistrationsController < Devise::RegistrationsController
  # This is a subclass of the devise registrations controller,
  # hence there is very little code here :)

  #overridden
  def create
    build_resource(sign_up_params)

    # this is the modification
    @civic = params[:civic]
    resource.check_f_membership(@civic)
    # end of modification

    resource_saved = resource.save
    yield resource if block_given?

    if resource_saved
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end


  protected
    #overridden
    def after_sign_up_path_for(resource)      
      edit_profile_path(resource.profile)
    end
    
end
