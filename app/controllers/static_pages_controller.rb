# encoding:UTF-8
class StaticPagesController < ApplicationController
  include TheRole::Controller
  
  skip_before_filter :authenticate_user!
  
  def cafe
  end
  def fos
  end
  def faq
  end  
  def kontakt
    @id = 0
    if (params[:till] != nil) && (List.where(category: 'kontakt').where(name: params[:till]).take != nil)
      @kontakt = List.where(category: 'kontakt').where(name: params[:till]).take
      @id = @kontakt.id
    end
    if (params[:id] != nil) && (List.where(category: 'kontakt').where(id: params[:id]) != nil)
      @kontakt = List.find(params[:id])
      @id = @kontakt.id
    end
    if user_signed_in?
      @kontaktlista = List.where(category: 'kontakt').sort_by{|l| l.name}
    else
      @kontaktlista = (List.where(category: 'kontakt').where(bool1: false) + List.where(category: 'kontakt').where(bool1: nil)).sort_by{|l| l.name}
    end
    if params[:id] != nil
      @kontakt = List.find(params[:id])
      @id = @kontakt.id
    end
    @name = params[:name]
    @email = params[:email]
    @msg = params[:msg]
    @recipient = params[:till]
    if(@name != nil) && (@email != nil) && (@msg != nil) && (@kontakt != nil)       
      ContactMailer.contact_email(@name,@email,@msg,@kontakt).deliver
      redirect_to kontakt_path     
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
  def index
    @news = News.all
  end
  
  private 
  def set_page
    @static_page = Page.find params[:id]
    @owner_check_object = @static_page 
  end
end

  
