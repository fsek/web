# encoding: UTF-8
class CalendarsController < ApplicationController
  #load_permissions_and_authorize_resource :calendar

  def index
    respond_to do |format|
      format.html
      format.js
    end
  end

  def export
    @calendar = Icalendar::Calendar.new
    @events.each do |e|
      @calendar.add_event(e)
    end

    @calendar.publish
    respond_to do |f|
      f.ics
    end
  end
end