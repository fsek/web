# encoding:UTF-8
class StaticPagesController < ApplicationController
  def company_offer
  end

  def company_about
  end

  def index
    @news = News.all_date.limit(4)

    date = Time.zone.now
    @events = Event.start.between(date.beginning_of_day, (date + 6.days).end_of_day)

    if current_user.nil?
      @notices = Notice.published
    else
      @notices = Notice.public_published
    end
  end
end
