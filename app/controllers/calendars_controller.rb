# encoding: UTF-8
class CalendarsController < ApplicationController
  load_permissions_then_authorize_resource class: false

  def index
    respond_to do |format|
      format.html
      format.json { render json: Event.translations.between(params[:start], params[:end]) }
    end
  end

  def export
    events = Event.translations.after_date(after_date)
    calendar = CalendarService.export(events, locale: locale)

    respond_to do |format|
      format.ics { render(text: calendar.to_ical) }
    end
  end

  def introduction
    introduction = Introduction.current
    if introduction.present?
      calendar = CalendarService.export(introduction.events(locale: locale), locale: locale)
      respond_to do |format|
        format.ics { render(text: calendar.to_ical) }
      end
    else
      redirect_to(export_calendars_path, status: 404)
    end
  end

  private

  def locale
    params.fetch(:locale, I18n.locale)
  end

  def after_date
    params.fetch(:calendar, {}).fetch(:after_date, nil)
  end
end
