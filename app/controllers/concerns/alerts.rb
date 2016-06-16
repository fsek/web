# Methods for easier controller alerts
module Alerts
  def model_name(model)
    return unless model.instance_of?(Class)

    model.model_name.human
  end

  def alert_update(resource)
    %(#{model_name(resource)} #{I18n.t('global_controller.success_update')}.)
  end

  def alert_create(resource)
    %(#{model_name(resource)} #{I18n.t('global_controller.success_create')}.)
  end

  def alert_destroy(resource)
    %(#{model_name(resource)} #{I18n.t('global_controller.success_destroy')}.)
  end
end
