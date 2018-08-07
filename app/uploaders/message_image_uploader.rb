class MessageImageUploader < BaseImageUploader
  storage :file

  # For saving original image without formatting or wratermarking
  def store_dir
    %(#{Rails.root}/storage/message_images/#{model.id})
  end

  def cache_dir
    %(#{Rails.root}/storage/message_images/tmp/#{model.id})
  end

  # Store dimensions of original
  process :fix_exif_rotation

  # Resizes to width 1680px (if the image is larger)
  version :large do
    process resize_to_fit: [1680, 10000]

    def store_dir
      %(#{Rails.root}/storage/message_images/#{model.id})
    end
  end

  # Creates a thumbnail version
  version :thumb do
    process resize_to_fit: [700, 700]

    def store_dir
      %(#{Rails.root}/storage/message_images/#{model.id})
    end
  end

  def fix_exif_rotation
    manipulate! do |img|
      img.auto_orient
      img = yield(img) if block_given?
      img
    end
  end
end
