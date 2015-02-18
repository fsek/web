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
  end
  
  private 
  def set_page
  end
end

  
