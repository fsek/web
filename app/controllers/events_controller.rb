# encoding:UTF-8
class EventsController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    respond_to do |format|
      format.html
      format.json { render json: @events }
    end
  end

  def show
  end
end
