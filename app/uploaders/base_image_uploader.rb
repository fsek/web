class BaseImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

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

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
