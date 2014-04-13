# encoding:UTF-8
class StaticPagesController < ApplicationController
  include TheRole::Controller
  
  before_action :login_required, only: [:bane]
  
  
  layout "static_page"
  skip_before_filter :authenticate_user!
  
  def cafe
  end
  def fos
  end
  def faq
  end  
  def kontakt
  end
  def kulturministerie
  end  
  def naringslivsutskott  
  end  
  def prylmasteri  
  end  
  def sanningsministerie  
  end
  def sexmasteri  
  end 
  def studierad  
  end  
  def styrelse
  end  
  def utskott  
  end  
  def libo  
  end 
  def kurslankar    
  end
  def bane  
  end
  
  private 
  def set_page
    @static_page = Page.find params[:id]
    @owner_check_object = @static_page 
  end
end

  
