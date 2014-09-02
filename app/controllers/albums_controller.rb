# encoding:UTF-8
class AlbumsController < ApplicationController
    
  before_filter :login_required
  before_filter :authenticate_user!
  before_filter :authenticate_gallery!, only: [:new, :create,:edit,:destroy,:update]
  before_action :set_album, only: [:show, :edit,:destroy,:update,:category]
  
  def index
    @albums = Album.all
    @kategorier = List.where(category: 'bildgalleri').all
    
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
    @kategorier = List.where(category: 'bildgalleri')
    @subcategories = Subcategory.all
  end
  def show    
    @sub_id = params[:subcategory_id].to_i
    if @sub_id.nil? == false && @sub_id.to_i > -1
      @subcategory = @sub_id.to_i
    else
      @subcategory = -1
    end
    if @sub_id > 0
      @images = @album.images.where(subcategory_id: @subcategory).sort_by{|image|image.captured}.reverse.slice(0,100)
    else
      @images = @album.images.sort_by{|image|image.captured}.reverse.slice(0,100)     
    end
    
  end
  def new
    @album = Album.new    
    @kategorier = List.where(category: 'bildgalleri')
    @subcategories = Subcategory.all
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
        format.html { redirect_to @album, :notice => 'Albumet uppdaterades!' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @album.errors, :status => :unprocessable_entity }
      end
    end
  end
  def random
    @album = Album.first
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