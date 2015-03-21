# encoding:UTF-8
class StaticPagesController < ApplicationController
  include TheRole::Controller

  skip_before_filter :authenticate_user!

  def faq
  end

  def libo
  end

  def kurslankar
  end

  def index
    @news = News.order(created_at: :desc).limit(5)
    @notices = (current_user.present?) ? Notice.published : Notice.public_published
  end

end
