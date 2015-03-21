# encoding:UTF-8
class StaticPagesController < ApplicationController
  def faq
  end
  def libo  
  end 
  def kurslankar    
  end
  def index
    @news = News.order('created_at desc LIMIT 5')
    if current_user.nil?
      @notices = Notice.published
    else
      @notices = Notice.public_published
    end
  end
  
  private 
  def set_page
  end
end

  
