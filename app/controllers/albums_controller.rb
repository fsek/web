class AlbumsController < ApplicationController
    layout 'static_page'
  before_action :set_album, only: [:show, :edit,:destroy,:update] 
  
  def index
    @albums = Album.all
    @images = Image.all
  end
  def edit
    @album = Album.find(params[:id])    
    @image = Image.new
  end
  def show
    @image = Image.new
    
  end
  def new
    @album = Album.new
    @image = Image.new
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
          format.html { redirect_to '/galleri', notice: 'Albumet skapades!' }
          format.json { render action: '/galleri', status: :created, location: @album }
        else
          format.html { render action: '/galleri' }
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
        format.html { redirect_to @album, :notice => 'Albumet uppdaterades!' }
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
      params.fetch(:image,{}).permit(:album_id)
    end
    def album_params
      params.fetch(:album,{}).permit(:title,:description,:author,:location,:public,:start_date,:end_date, images_parameters: [:id, :foto])
    end
end