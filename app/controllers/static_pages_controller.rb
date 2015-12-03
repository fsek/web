# encoding:UTF-8
class StaticPagesController < ApplicationController
  load_permissions_and_authorize_resource class: :static_pages

  def about
  end

  def company_offer
  end

  def company_about
  end

  def index
    @news = News.order(created_at: :desc).limit(5)

    date = Time.zone.now
    @events = Event.start.between(date.beginning_of_day, (date + 6.days).end_of_day)

    if current_user.nil?
      @notices = Notice.published
    else
      @notices = Notice.public_published
    end
  end
end
