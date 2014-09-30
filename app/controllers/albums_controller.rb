# encoding:UTF-8
class AlbumsController < ApplicationController
    
  before_filter :login_required
  before_filter :authenticate_user!
  before_filter :authenticate_gallery!, only: [:new, :create,:edit,:destroy,:update,:settings,:destroy_images]
  before_action :set_album, only: [:show, :edit,:destroy,:update,:category,:upload_images]
  
  def index
    @albums = Album.unscoped.order('start_date asc')
    @albums_latest = Album.unscoped.order('created_at asc LIMIT 4')
    @kategorier = PhotoCategory.unscoped.order('name desc')
    
    if (params[:id] != nil) && (params[:datum] != "")     
      @id = params[:id]
      @datum = Date.parse(params[:datum])  
      if @datum < Date.today
        if @kategorier.find(@id).name == " "
            @searched = Album.where(:start_date => @datum..Date.today).all
        else                
          @searched = Album.where(:category => @kategorier.find(@id).name, :start_date => @datum...Date.today).all
        end
      end
    elsif (params[:id]) && (params[:datum] == "" )
      @id = params[:id]
      @searched = Album.where(:category => @kategorier.find(@id).name)    
    end
      
  end
  def edit    
    @kategorier = PhotoCategory.unscoped.order('name desc')
    @subcategories = Subcategory.unscoped.order('text desc')
  end
  def settings
    unless @kategori
      @kategori = PhotoCategory.new
    end    
    unless @kategorier       
      @kategorier = PhotoCategory.unscoped.order('name desc')
    end
    
    if (params[:commit] == "Spara ny kategori") && (params[:photo_category][:name] != nil) 
      @kategori.update(name: params[:photo_category][:name],text: params[:photo_category][:text],visible: params[:photo_category][:visible])
      if @kategori.save        
        flash.now[:notice] = 'Kategorin '+@kategori.name+' skapades till Bildgalleriet'
        @kategorier = PhotoCategory.unscoped.order('name desc')
        @kategori = PhotoCategory.new
      end      
    end
        
    if (params[:commit] == 'Spara kategori') && (params[:photo_category][:id].nil? == false)
      @kategorin = PhotoCategory.find(params[:photo_category][:id])      
      @kategorin.update(name: params[:photo_category][:name],text: params[:photo_category][:text],visible: params[:photo_category][:visible])
      if @kategorin.save
        @kategorier = PhotoCategory.unscoped.order('name desc')
        flash.now[:notice] = 'Kategorin '+@kategorin.name+' uppdaterades till Bildgalleriet'
      end
    end
    
    if (params[:commit] == 'Ta bort kategori')&&(params[:photo_category])    
      @category = PhotoCategory.find(params[:photo_category][:id]).destroy
      @kategorier = PhotoCategory.all      
      flash.now[:notice] = 'Kategorin togs bort'
    end
    
    unless @subcategory
      @subcategory = Subcategory.new
    end    
    unless @subcategories       
      @subcategories = Subcategory.unscoped.order('text desc')
    end
    
    if (params[:commit] == "Spara ny underkategori") && (params[:subcategory][:text] != nil) 
      @subcategory.update(text: params[:subcategory][:text])
      if @subcategory.save        
        flash.now[:notice] = 'Underkategorin '+@subcategory.text+' skapades till Bildgalleriet'
        @subcategory = Subcategory.new()
        
      end      
    end
        
    if (params[:commit] == 'Spara underkategori') && (params[:subcategory][:id].nil? == false)
      @subcategory = Subcategory.find(params[:subcategory][:id].nil? == false)      
      @subcategory.update(text: params[:subcategory][:text])
      if @subcategory.save
        @subcategories = Subcategory.unscoped.order('text desc')
        flash.now[:notice] = 'Underkategorin '+@subcategory.text+' uppdaterades till Bildgalleriet'
      end
    end
    
    if (params[:commit] == 'Ta bort underkategori')&&(params[:subcategory][:id].nil? == false)    
      @category = Subcategory.find(params[:subcategory][:id]).destroy
      @subcategories = Subcategory.unscoped.order('text desc')      
      flash.now[:notice] = 'Kategorin togs bort'
    end
  end 
  
  def show    
    @sub_id = params[:subcategory_id].to_i
    if (@sub_id.nil? == false) && (@sub_id.to_i > -1)
      @subcategory = @sub_id.to_i
    else
      @subcategory = -1
    end
    if (@sub_id > 0) && (@album.images)
      @images = @album.images.where(subcategory_id: @subcategory).order('foto_file_name asc')
    elsif (@album.images)
      @images = @album.images.order('foto_file_name asc')
    else
      @images = nil      
    end    
  end
  def new
    @album = Album.new    
    @kategorier = PhotoCategory.unscoped.order('name asc')
    @subcategories = Subcategory.unscoped.order('text asc')
  end
  
  def create
      @album = Album.new(album_params)      
      @album.update(author: current_user.profile)    
      respond_to do |format|
        if @album.save
            if params[:images]
              params[:images].each {|image| 
                @album.images.create(image: image)
                }
            end
            if params[:subcategories]
              params[:subcategories].each {|category|              
                if(@album.subcategory_ids.include?(category.id) == false)
                  @album.subcategories << category
                end
              }
            end
          format.html { redirect_to @album, notice: 'Albumet skapades!' }
          format.json { render :json => @album, :status => :created, :location => @album }
        else
          format.html { render action: "new" }
          format.json { render json: @album.errors, status: :unprocessable_entity }
        end
      end
  end
    
  def destroy    
    @album.destroy
    respond_to do |format|
      format.html { redirect_to albums_url }
      format.json { head :no_content }
    end
  end
  def destroy_images
    for image in @album.images
      image.destroy
    end
    respond_to do |format|
      format.html { redirect_to @album, notice: 'Bilderna tog borts!' }
      format.json { render :json => @album, :location => @album }
    end
  end
  def upload_images
    if (params[:fotos]) && (params[:subcategory_id])
        #===== The magic is here ;)
          params[:fotos].each { |foto|
            @album.images.create(foto: foto,subcategory_id: params[:subcategory_id])
          }
    end    
  end
  def update
    respond_to do |format|
      if @album.update_attributes(album_params)
        if params[:subcategories]
                params[:subcateogories].each { |category|
                  if(@album.subcategory_ids.include?(category.id) == false)
                    @album.subcategories << category
                  end
                }
          end                      
        format.html { redirect_to edit_album_path(@album), :notice => 'Albumet uppdaterades!' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @album.errors, :status => :unprocessable_entity }
      end
    end
  end  
    private
    def set_album
      @album = Album.find(params[:id])      
    end
    def image_params
      params.fetch(:image,{}).permit(:album_id,:subcategory_id)
    end
    def album_params
      params.fetch(:album,{}).permit(:title,:category,:description,:author,:location,:public,:start_date,:end_date,:subcategory_ids => [],images_parameters: [:id, :foto])
    end
end