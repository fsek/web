# encoding: UTF-8
class Admin::EventRegistrationsController < Admin::BaseController
  load_and_authorize_resource :event, parent: true
  load_permissions_and_authorize_resource

  def index
  end

end
