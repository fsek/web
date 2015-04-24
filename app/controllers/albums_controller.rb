# encoding:UTF-8
class AlbumsController < ApplicationController
  load_permissions_and_authorize_resource
  load_and_authorize_resource :image, through: :album
  before_action :set_edit
  before_action :categories

  def index
    @albums = Album.order('start_date asc')
    @albums_latest = Album.order('created_at desc LIMIT 4')
  end

  def edit
  end

  # TODO add Settings somewhere else

  def show
    if (@album.images)
      @images = @album.images.order('foto_file_name asc')
    else
      @images = nil
    end
  end

  def new
  end

  def create
    @album = Album.new(album_params)
    @album.author = current_user
    if @album.save
      redirect_to @album, notice: 'Albumet skapades!'
    else
      render action: :new
    end
  end

  def destroy
    @album.destroy
    redirect_to albums_url, notice: 'Albumet raderades.'
  end

  def destroy_images
    for image in @album.images
      image.destroy
    end
    redirect_to @album, notice: 'Bilderna tog borts!'
  end

  def upload_images
    if (params[:fotos]) && (params[:subcategory_id])
      #===== The magic is here ;)
      @count = 1
      @total = params[:fotos].count
      params[:fotos].each do |foto|
        flash[:notice] = %(Laddar upp #{@count}/#{@total})
        @album.images.create(foto: foto, subcategory_id: params[:subcategory_id])
        @count = @count + 1
      end
      flash[:notice] = %(Färdig! Laddat upp #{@total} bilder.)
    end
  end

  def update
    if @album.update(album_params)
      redirect_to edit_album_path(@album), notice: 'Albumet uppdaterades!'
    else
      render action: :edit
    end
  end

  private

  def categories
    @kategorier = AlbumCategory.order('name desc')
    @subcategories = Subcategory.order('text desc')
  end

  def set_edit
    @edit = can? :manage, Album
  end

  def album_params
    params.require(:album).permit(:title, :description, :author, :location,
                                  :public, :start_date, :end_date, album_category_ids: [],
                                  subcategory_ids: [], images_parameters: [:id, :foto])
  end
end
