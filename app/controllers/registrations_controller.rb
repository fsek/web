class RegistrationsController < Devise::RegistrationsController
  # This is a subclass of the devise registrations controller,
  # hence there is very little code here :)

  protected
    def after_sign_up_path_for(resource)
      puts "YEEEEEEEEEEEEEEEEEEEEAAAAAAAAAAAAAAAAAAAAAAAAAAHHHHHHHHHHHHHHHHHHHH\nYEEEEEEEEEEEEEEEEEEAAAAAAAAAAAAAAAAAAHHHHHHHHH"
      edit_profile_path(resource.profile)
    end
end
