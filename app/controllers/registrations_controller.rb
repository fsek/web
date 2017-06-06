class RegistrationsController < Devise::RegistrationsController
  def create
    if !verify_recaptcha
      build_resource(sign_up_params)
      resource.valid?
      resource.errors.add(:recaptcha, t('model.user.recaptcha_error'))
      clean_up_passwords(resource)
      respond_with_navigational(resource) { render :new }
    else
      flash.delete :recaptcha_error
      super do |resource|
        if resource.persisted?
          # Required for devise to send confirmation emails
          # when used with the devise_token_auth gem
          resource.send_confirmation_instructions
        end
      end
    end
  end
end
