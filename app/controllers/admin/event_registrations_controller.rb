# encoding: UTF-8
class Admin::EventRegistrationsController < Admin::BaseController
  load_and_authorize_resource :event, parent: true
  load_permissions_and_authorize_resource

  def index
    @attending_grid = initialize_grid(EventRegistration.attending(@event),
                                      include: :user,
                                      order: :created_at,
                                      name: :attending)
    @reserve_grid = initialize_grid(EventRegistration.reserves(@event),
                                    include: :user,
                                    order: :created_at,
                                    name: :reserves)
  end
end
