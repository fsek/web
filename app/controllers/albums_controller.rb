# encoding:UTF-8
class AlbumsController < ApplicationController
    
  before_filter :login_required  
  before_filter :authenticate, only: [:new, :create,:edit,:destroy,:update,:settings,:destroy_images]
  before_action :set_edit
  before_action :set_album, except: [:index,:new,:create,:settings]
  before_action :categories
  
  def index
    @albums = Album.order('start_date asc')
    @albums_latest = Album.order('created_at desc LIMIT 4')    
    
    if (params[:id] != nil) && (params[:datum] != "")     
      @id = params[:id]
      @datum = Date.parse(params[:datum])  
      if @datum < Date.today
        if @kategorier.find_by_id(@id)
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
    if(params[:commit]) && (current_user) && (current_user.moderator?(:galleri))
      if(params[:commit] == 'Markera alla')
        @mark = true
      elsif(params[:commit] == 'Ta bort markerade') && (params[:image_ids])
        params[:image_ids].each { |img_id|
          img = Image.find_by_id(img_id)
          if(img)
            img.destroy
          end
        }
        flash.now[:notice] = 'De markerade bilderna togs bort.'
      elsif(params[:commit] == 'Byt kategori') && (params[:image_ids]) && (params[:image_category])
        params[:image_ids].each { |img_id|
          img = Image.find_by_id(img_id)
          if(img)
            img.subcategory_id = params[:image_category]
            img.save()
          end
        }
        flash.now[:notice] = 'De markerade bilderna har nu kategorin: '+Subcategory.find_by_id(params[:image_category]).text
      end
    end
    
    
  end
  
  def settings
    unless @kategori
      @kategori = AlbumCategory.new
    end    
    unless @kategorier       
      @kategorier = AlbumCategory.order('name desc')
    end
    
    if (params[:commit] == "Spara ny kategori") && (params[:album_category][:name] != nil) 
      @kategori.update(name: params[:album_category][:name],text: params[:album_category][:text],visible: params[:album_category][:visible])
      if @kategori.save        
        flash.now[:notice] = 'Kategorin '+@kategori.name+' skapades till Bildgalleriet'
        @kategorier = AlbumCategory.order('name desc')
        @kategori = AlbumCategory.new
      end      
    end
        
    if (params[:commit] == 'Spara kategori') && (params[:album_category][:id].nil? == false)
      @kategorin = AlbumCategory.find(params[:album_category][:id])      
      @kategorin.update(name: params[:album_category][:name],text: params[:album_category][:text],visible: params[:album_category][:visible])
      if @kategorin.save
        @kategorier = AlbumCategory.unscoped.order('name desc')
        flash.now[:notice] = 'Kategorin '+@kategorin.name+' uppdaterades till Bildgalleriet'
      end
    end
    
    if (params[:commit] == 'Ta bort kategori')&&(params[:album_category])    
      @category = AlbumCategory.find_by_id(params[:album_category][:id]).destroy
      @kategorier = AlbumCategory.all      
      flash.now[:notice] = 'Kategorin togs bort'
    end
    
    unless @subcategory
      @subcategory = Subcategory.new
    end    
    unless @subcategories       
      @subcategories = Subcategory.order('text desc')
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
    if (@album.images)
      @images = @album.images.order('foto_file_name asc')
    else
      @images = nil      
    end    
  end
  
  def new
    @album = Album.new
  end
  
  def create
      @album = Album.new(album_params)      
      @album.update(author: current_user.profile)    
      respond_to do |format|
        if @album.save                        
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
      format.html { redirect_to albums_url,notice: 'Albumet raderades.' }
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
        @count = 1
        @total = params[:fotos].count
          params[:fotos].each { |foto|
            flash[:notice] =("Laddar upp "+@count.to_s+"/"+@total.to_s)
            @album.images.create(foto: foto,subcategory_id: params[:subcategory_id])
            @count = @count+1;
          }
          flash[:notice] =("Färdig!   Laddat upp "+@total.to_s+" bilder.")
    end    
  end
  def update
    respond_to do |format|
      if @album.update_attributes(album_params)                
        format.html { redirect_to edit_album_path(@album), :notice => 'Albumet uppdaterades!' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @album.errors, :status => :unprocessable_entity }
      end
    end
  end  
private
  def authenticate
    flash[:error] = t('the_role.access_denied')
    redirect_to(:back) unless current_user.moderator?(:galleri)
    
    rescue ActionController::RedirectBackError
      redirect_to root_path
  end
  def categories
     @kategorier = AlbumCategory.order('name desc')
     @subcategories = Subcategory.order('text desc')
  end
  def set_album
    @album = Album.find(params[:id])      
  end
  def set_edit
   if (current_user) && (current_user.moderator?(:galleri))
     @edit = true
   else
     @edit = false
   end
  end
  def image_params
    params.fetch(:image,{}).permit(:album_id,:subcategory_id)
  end
  def album_params
    params.fetch(:album,{}).permit(:title,:description,:author,:location,:public,:start_date,:end_date,:album_category_ids => [],:subcategory_ids => [],images_parameters: [:id, :foto])
  end
end