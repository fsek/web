class ImageUploader < BaseImageUploader
  include ::CarrierWave::Backgrounder::Delay
  before :cache, :save_original_filename

  storage :file

  # For saving original image without formatting or wratermarking
  def store_dir
    %(#{Rails.root}/storage/#{model.parent.class.name.pluralize.downcase}/#{model.parent.id})
  end

  # Store dimensions of original
  process :store_dimensions
  process :fix_exif_rotation

  # Resizes to width 1680px (if the image is larger)
  version :large do
    process resize_to_fit: [1680, 10000]
    process :watermark

    def store_dir
      %(uploads/#{model.parent.class.name.pluralize.downcase}/#{model.parent.id}/large)
    end
  end

  # Creates a thumbnail version
  version :thumb do
    process resize_to_fill: [350, 350]

    def store_dir
      %(uploads/#{model.parent.class.name.pluralize.downcase}/#{model.parent.id}/thumb)
    end
  end

  # Watermark should always be processed after thumbkit, ensuring that we always
  # have a valid image and we don't need to change the extension
  def watermark(options = {})
    cache_stored_file! if !cached?
    Watermarker.new(current_path).watermark!(options)
  end

  def save_original_filename(file)
    model.filename ||= file.original_filename if file.respond_to?(:original_filename)
  end

  # To store initial filesize and filename in model
  def store_dimensions
    if file && model
      model.width, model.height = ::MiniMagick::Image.open(file.file)[:dimensions]
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
