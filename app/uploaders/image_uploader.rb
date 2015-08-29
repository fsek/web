# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :file

  # Override the directory where uploaded files will be stored.
  # Can be changed in model.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    %(#{Rails.root}/storage/#{model.parent.class.name.pluralize.downcase}/#{model.parent.id})
  end


  # Will resize to 800px wide, the large height is to make it stop at width
  # first.
  version :large do
    process resize_to_fit: [1600, 10000]
    process watermark: [Rails.root.join('app/assets/images/layout/f-80.png')]

    def store_dir
      %(uploads/#{model.parent.class.name.pluralize.downcase}/#{model.parent.id}/large)
    end
  end

  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fill: [200, 200]

    def store_dir
      %(uploads/#{model.parent.class.name.pluralize.downcase}/#{model.parent.id}/thumb)
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Own config /dwessman
  def md5
    chunk = model.send(mounted_as)
    @md5 ||= Digest::MD5.hexdigest(chunk.read.to_s)
  end

  def filename
    @name ||= "#{md5}#{File.extname(super)}" if super
  end

  # Watermark should always be processed after thumbkit, ensuring that we always
  # have a valid image and we don't need to change the extension
  def watermark(watermark_image, options = {})
    cache_stored_file! if !cached?
    Watermarker.new(current_path,
                    watermark_image).watermark!(options)
  end
end
