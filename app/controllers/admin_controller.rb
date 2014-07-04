#encoding: utf-8 
class AdminController < ApplicationController
    include TheRole::Controller
  before_filter :authenticate_user! 
 
  def kontakt
    unless @kontakt
      @kontakt = List.new
    end
    unless @kontakten
      @kontakten = List.new
    end
    unless @kontakter       
      @kontakter = List.where(:category => 'kontakt').sort_by{|l| l.name}
    end
    if (params[:commit] == "Ny kontakt") && (params[:list][:name] != nil) 
      @kontakt.name = params[:list][:name]
      @kontakt.string1 = params[:list][:string1]
      @kontakt.bool1 = params[:list][:bool1]
      @kontakt.category = "kontakt"
      if @kontakt.save
        @kontakten = @kontakt
        flash.now[:notice] = 'Kontaktpost för '+@kontakt.name+' skapades'
      end      
    end
    if (params[:id] != nil) 
      @kontakten = List.find(params[:id])
           
    end
    if (params[:commit] == 'Spara') && (@kontakten != nil)
      @kontakten.name = params[:name]
      @kontakten.string1 = params[:string1]
      @kontakten.bool1 = params[:bool1]      
      if @kontakten.save
        flash.now[:notice] = 'Kontaktpost för '+@kontakten.name+' uppdaterades'
      end
    end
  end
  def bildgalleri
    unless @kategori
      @kategori = List.new
    end
    unless @kategorin
      @kategorin = List.new
    end
    unless @kategorier       
      @kategorier = List.where(:category => 'bildgalleri').sort_by{|l| l.name}
    end    
    if (params[:commit] == "Ny kontakt") && (params[:list][:name] != nil) 
      @kategori.update(name: params[:list][:name],string1: params[:list][:string1],category: 'bildgalleri')
      if @kategori.save
        @kategorin = @kategori
        flash.now[:notice] = 'Kategorin '+@kategorin.name+' skapades till Bildgalleriet'
      end      
    end
    if (params[:id] != nil)
      @kategorin = List.find(params[:id])
    end
    if (params[:commit] == 'Spara') && (@kategorin != nil)      
      @kategorin.update(name: params[:list][:name], string1: params[:list][:string1])
      if @kategorin.save
        flash.now[:notice] = 'Kategorin '+@kategorin.name+' uppdaterades till Bildgalleriet'
      end
    end
  end
  def utskott
    unless @utskott
      @utskott = List.new
    end
    unless @utskottet
      @utskottet = List.new
    end
    unless @utskotten       
      @utskotten = List.where(:category => 'utskott').sort_by{|l| l.name}
    end    
    if (params[:commit] == "Nytt utskott") && (params[:list][:name] != nil) 
      @utskott.update(name: params[:list][:name],string1: params[:list][:string1],category: 'utskott')
      if @utskott.save
        @utskottet = @utskott
        flash.now[:notice] = 'Utskottet '+@utskottet.name+' skapades'
      end      
    end
    if (params[:id] != nil)
      @utskottet = List.find(params[:id])
      @id = params[:id]
    end
    if (params[:commit] == 'Spara') && (@utskottet != nil)      
      @utskottet.update(name: params[:list][:name], string1: params[:list][:string1])
      if @utskottet.save
        flash.now[:notice] = 'Utskottet '+@utskottet.name+' uppdaterades'
      end
    end
  end  
  
  private
    def kontakt_params
        params.fetch(:kontakt,{}).permit(:name,:string1,:bool1)
    end   
end