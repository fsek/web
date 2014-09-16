# encoding:UTF-8
class ImagesController < ApplicationController
  before_filter :login_required
  before_filter :authenticate_user!  
  before_action :set_image, only: [:show, :edit, :update, :destroy]
  before_action :set_album, only: [:index,:new,:create, :show, :edit, :update, :destroy,:edit_multiple,:update_multiple]
  # GET /uploads
  # GET /uploads.json
  def index
    @images = @album.images.unscoped.order('foto_file_name asc')
  end

  # GET /uploads/1
  # GET /uploads/1.json
  def show
  end

  # GET /uploads/new
  def new
    @image = Image.new     
  end

  # GET /uploads/1/edit
  def edit
  end
  
  def edit_multiple
    @images = @album.images.unscoped.order('foto_file_name asc')
    @image = @images.first
  end
  def update_multiple
  @images = @album.images
  @images.each do |image|
    image.update_attributes!(params[:image].reject { |k,v| v.blank? })
  end
  flash[:notice] = "Bilderna uppdaterades!"
  redirect_to album_images_path(@album)
end

  # POST /uploads
  # POST /uploads.json
  def create    
    @image = @album.images.create(image_params)
    if params[:image][:subcategories]
      @image.subcategory = Subcategory.find(params[:image][:subcategories]);
    end
    respond_to do |format|
      if @image.save
        format.html { redirect_to @album, notice: 'Bilden lades till.' }
        format.json { head :no_content }
      else
        format.html { render action: 'new' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /uploads/1
  # PATCH/PUT /uploads/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: 'Bilden uppdaterades.' }
        format.json { head :no_content }
      else
        format.html { render action: 'new' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uploads/1
  # DELETE /uploads/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to edit_album_path(@album), notice: "Bilden togs bort." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end
    
    def set_album
      @album = Album.find(params[:album_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.fetch(:image).permit(:foto,:album_id,:subcategory_id)
    end
end