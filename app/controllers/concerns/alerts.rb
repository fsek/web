# Methods for easier controller alerts
module Alerts
  def model_name(model)
    return unless model.instance_of?(Class)

    model.model_name.human
  end

  def alert_update(resource)
    {text: %(#{model_name(resource)} #{I18n.t("global_controller.success_update")}.),
     type: "success"}
  end

  def alert_create(resource)
    {text: %(#{model_name(resource)} #{I18n.t("global_controller.success_create")}.),
     type: "success"}
  end

  def alert_destroy(resource)
    {text: %(#{model_name(resource)} #{I18n.t("global_controller.success_destroy")}.),
     type: "danger"}
  end

  def alert_errors(errors)
    {errors: errors, type: "errors"}
  end

  def alert_success(message)
    {text: message, type: "success"}
  end

  def alert_danger(message)
    {text: message, type: "danger"}
  end
end
