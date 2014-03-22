class StaticPagesController < ApplicationController  
  respond_to :html
  # encoding: UTF-8
  layout "static_page"
  
  def cafe
  add_breadcrumb "Utskott",:utskott_path
  add_breadcrumb "Cafémästeriet",:cafe_path  
  end
  
  def fos
  add_breadcrumb "Utskott",:utskott_path
  add_breadcrumb "Föset",:fos_path  
  end
  
  def kulturministerie
  add_breadcrumb "Utskott",:utskott_path
  add_breadcrumb "Kulturministeriet",:km_path
  end
  
  def naringslivsutskott
  add_breadcrumb "Utskott",:utskott_path
  add_breadcrumb "Näringslivsutskottet",:fnu_path
  end
  
  def prylmasteri
  add_breadcrumb "Utskott",:utskott_path
  add_breadcrumb "Prylmästeriet",:pryl_path
  end
  
  def sanningsministerie
  add_breadcrumb "Utskott",:utskott_path
  add_breadcrumb "Sanningsministeriet",:sanning_path
  end

  def sexmasteri
  add_breadcrumb "Utskott",:utskott_path
  add_breadcrumb "Sexmästeriet",:sexmasteri_path
  end
 
  def studierad
  add_breadcrumb "Utskott",:utskott_path
  add_breadcrumb "Studierådet",:studierad_path
  end
  
  def styrelse    
    add_breadcrumb "Styrelsen",:styrelse_path
  end
  
  def utskott
      add_breadcrumb "Utskott",:utskott_path
  end
  
  def libo
    add_breadcrumb "Likabehandlingsombud",:libo_path
  end  

end

  
