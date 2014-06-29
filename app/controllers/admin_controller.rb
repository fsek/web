class AdminController < ApplicationController
    include TheRole::Controller
  before_filter :authenticate_user! 
 
  def kontakt
    @kontakt = List.new       
    @kontakter = List.all
    if (params[:commit] == "Ny kontakt") && (params[:list][:name] != nil) 
      @kontakt.name = params[:list][:name]
      @kontakt.string1 = params[:list][:string1]
      @kontakt.bool1 = params[:list][:bool1]
      @kontakt.category = "kontakt"
      if @kontakt.save
        redirect_to admin_kontakt_path, notice: @kontakt.name + 'Uppdaterades!'
      end      
    end
    if (params[:id] != nil) 
      @kontakten = List.find(params[:id])
    end
    if (params[:commit] == 'Spara') && (@kontakten.name != nil)
      @kontakten.name = params[:name]
      @kontakten.string1 = params[:string1]
      @kontakten.bool1 = params[:bool1]      
      if @kontakten.save
        redirect_to admin_kontakt_path(:id => params[:id])
      end
    end
    

  end
  def collections
    if params[:list] == "Bildkategorier"
      @kategorier = Collections.bildkategori
      if params[:commit] == 'Redigera'
        @kategori = params[:change]
      end
      if (params[:change] != nil) && (params[:commit] == 'Ta bort')
        Collections.bildkategoriremove(params[:change])
      end
      if (params[:ny] != nil) && (params[:ny] != "") && (params[:commit] == 'Lägg till')
        Collections.bildkategoriadd(params[:ny])
        redirect_to admin_kategorier_path
      end
      if (params[:text] != nil) && (params[:test] != "") && (params[:commit] == "Redigera")
        Collections.bildkategorichange(params[:bild],params[:text]) 
        redirect_to admin_kategorier_path(:list == params[:list])      
      end
    end
    
    if params[:list] == "Kontaktlista"
      @kategorier = Collections.kontaktlista
      if params[:commit] == 'Redigera'
        @kategori = params[:change]
      end
      if (params[:change] != nil) && (params[:commit] == 'Ta bort')
        Collections.kontaktlistaremove(params[:change])
      end
      if (params[:ny] != nil) && (params[:ny] != "") && (params[:commit] == 'Lägg till')
        Collections.kontaktlistaadd(params[:ny])
        redirect_to admin_kategorier_path
      end
      if (params[:text] != nil) && (params[:test] != "") && (params[:commit] == "Redigera")
        Collections.kontaktlistachange(params[:bild],params[:text]) 
        redirect_to admin_kategorier_path(:list == params[:list])  
      end
    end
     
  end
  private
    def kontakt_params
        params.fetch(:kontakt,{}).permit(:name,:commit,:string1,:bool1)
    end   
end