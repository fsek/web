# encoding: UTF-8
class Nollning::NollningsController < ApplicationController
  load_permissions_then_authorize_resource class: false

  def index
    @page = Page.find_by(namespace: :nollning, title: 'Startsida')
  end

  def matrix
    @events = Event.nollning
  end

  def modal
    @date = Date.strptime(%({#{params[:date]}}), "{%Y-%m-%d}")
    @events = Event.from_date(@date)
    respond_to do |format|
      format.html
      format.js
    end
  end
end
