class AlbumService
  def initialize
    @uploaded = 0
  end

  def uploaded
    @uploaded || 0
  end

  def upload_images(album)
    state = true
    if album.image_upload.present?
      album.image_upload.each do |img|
        new_img = album.images.new(file: img, photographer_id: album.photographer_user,
                                   photographer_name: album.photographer_name)
        if new_img.save
          @uploaded += 1
        else
          album.errors.add(:image_upload, new_img.filename)
          state = false
        end
      end
    end

    state
  end
end
