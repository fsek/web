# encoding: utf-8
class AttachedImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file
  process resize_to_fit: [1200, 10000]

  # For saving original image without formatting or wratermarking
  def store_dir
    %(uploads/#{model.class.name.pluralize.downcase}/#{model.id})
  end

  # Creates a thumbnail version
  version :thumb do
    process resize_to_fill: [350, 350]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Used for hashing filename
  def filename
    @name ||= "#{md5}#{File.extname(super)}" if super
  end

  def md5
    chunk = model.send(mounted_as)
    @md5 ||= Digest::MD5.hexdigest(chunk.read.to_s)
  end
end
