# encoding: utf-8
class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  # For saving original image without formatting or wratermarking
  def store_dir
    %(#{Rails.root}/storage/#{model.parent.class.name.pluralize.downcase}/#{model.parent.id})
  end
  # Store dimensions of original
  process :store_dimensions

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

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Used for hashing filename
  def filename
    if original_filename
      if model && model.read_attribute(mounted_as).present?
        model.read_attribute(mounted_as)
      else
        @name ||= %(#{File.basename(super, File.extname(super))}_#{md5}#{File.extname(super)}) if super
      end
    end
  end

  def md5
    chunk = model.send(mounted_as)
    @md5 ||= Digest::MD5.hexdigest(chunk.read.to_s)
  end

  # Watermark should always be processed after thumbkit, ensuring that we always
  # have a valid image and we don't need to change the extension
  def watermark(options = {})
    cache_stored_file! if !cached?
    Watermarker.new(current_path).watermark!(options)
  end

  # To store initial filesize and filename in model
  def store_dimensions
    if file && model
      model.width, model.height = ::MiniMagick::Image.open(file.file)[:dimensions]
      model.filename = file.filename
    end
  end
end
