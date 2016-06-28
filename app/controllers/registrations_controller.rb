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
      super
    end
  end
end
