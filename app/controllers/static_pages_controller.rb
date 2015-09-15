# encoding:UTF-8
class StaticPagesController < ApplicationController
  def company_offer
  end

  def company_about
  end

  def index
    @news = News.order(created_at: :desc).limit(5)
    date = Time.zone.now
    @events = Event.between(date.beginning_of_day, (date + 7.days).end_of_day).limit(5)

    if current_user.nil?
      @notices = Notice.published
    else
      @notices = Notice.public_published
    end
  end
end
