class ApiImageUploader < BaseImageUploader
  storage :file

  # For saving original image without formatting or wratermarking
  def store_dir
    %(#{Rails.root}/storage/api_images/#{model.id})
  end

  def cache_dir
    %(#{Rails.root}/storage/api_images/tmp/#{model.id})
  end

  # Store dimensions of original
  process :fix_exif_rotation
  process :store_dimensions

  # Resizes to width 1680px (if the image is larger)
  version :large do
    process resize_to_fit: [1680, 10000]
    process :store_dimensions

    def store_dir
      %(#{Rails.root}/storage/api_images/#{model.id})
    end
  end

  # Creates a thumbnail version
  version :thumb do
    process resize_to_fit: [700, 700]
    process :store_dimensions

    def store_dir
      %(#{Rails.root}/storage/api_images/#{model.id})
    end
  end

  def fix_exif_rotation
    manipulate! do |img|
      img.auto_orient
      img = yield(img) if block_given?
      img
    end
  end

  def store_dimensions
    if file && model
      dimensions = ::MiniMagick::Image.open(file.file)[:dimensions]
      image_version = version_name || :original

      model.image_details = {} if model.image_details.nil?
      model.image_details[image_version] = dimensions
    end
  end
end
