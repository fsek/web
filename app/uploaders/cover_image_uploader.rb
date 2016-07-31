class CoverImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    %(#{Rails.root}/storage/#{model.class.name.pluralize.downcase}/#{model.id})
  end

  version :large do
    process resize_to_fit: [10000, 1000]

    def store_dir
      %(uploads/#{model.class.name.pluralize.downcase}/#{model.id})
    end
  end

  version :thumb do
    process resize_to_fill: [800, 200]

    def store_dir
      %(uploads/#{model.class.name.pluralize.downcase}/#{model.id})
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    if original_filename && model && model.read_attribute(mounted_as).present?
      model.read_attribute(mounted_as)
    elsif original_filename && super
      @name ||= %(#{File.basename(super, File.extname(super))}_#{md5}#{File.extname(super)})
    end
  end

  def md5
    chunk = model.send(mounted_as)
    @md5 ||= Digest::MD5.hexdigest(chunk.read.to_s)
  end
end
