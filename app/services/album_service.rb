module AlbumService
  def self.upload_images(album)
    if album.image_upload.present?
      album.image_upload.each do |img|
        album.images.create(file: img, photographer_id: album.photographer_user,
                            photographer_name: album.photographer_name)
      end
    end

    # Perhaps in a later state there should be validations on images
    # Right now we return true if images upload without raising errors
    # or if there are no images.
    true
  end
end
