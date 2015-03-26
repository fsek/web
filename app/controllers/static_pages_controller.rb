# encoding:UTF-8
class StaticPagesController < ApplicationController
  def company_offer
  end

  def company_about
  end

  def index
    @news = News.order('created_at desc LIMIT 5')
    if current_user.nil?
      @notices = Notice.published
    else
      @notices = Notice.public_published
    end
  end
end

  
