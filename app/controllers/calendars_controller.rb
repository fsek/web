# encoding: UTF-8
class CalendarsController < ApplicationController
  load_permissions_then_authorize_resource class: false

  def index
    respond_to do |format|
      format.html
      format.json { render json: Event.calendar }
    end
  end

  def export
    @calendar = Icalendar::Calendar.new
    Event.calendar.each do |e|
      @calendar.add_event(e.ical)
    end

    @calendar.publish
    respond_to do |format|
      format.ics
    end
  end
end
