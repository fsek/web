# encoding:UTF-8
class StaticPagesController < ApplicationController
  include TheRole::Controller
  
  layout "static_page"
  skip_before_filter :authenticate_user!
  
  def cafe
  end
  def fos
  end
  def faq
  end  
  def kontakt
    if @sent == nil
      @sent = false
    end
    if params[:recipient] != nil
      @sent = true
      ContactMailer.contact_email(params[:name],params[:email],params[:msg],params[:recipient]).deliver      
    end
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
  
  private 
  def set_page
    @static_page = Page.find params[:id]
    @owner_check_object = @static_page 
  end
end

  
