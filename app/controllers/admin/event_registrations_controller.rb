# encoding: UTF-8
class Admin::EventRegistrationsController < ApplicationController
  load_and_authorize_resource :event, parent: true
  load_permissions_and_authorize_resource
  before_action :admin_authorize

  def index
  end

  private

  def admin_authorize
    authorize!(:manage, EventRegistration)
  end
end
