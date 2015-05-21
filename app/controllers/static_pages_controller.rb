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
    @news = News.order('created_at desc LIMIT 5')
    if current_user.nil?
      @notices = Notice.published
    else
      @notices = Notice.public_published
    end
  end
end
