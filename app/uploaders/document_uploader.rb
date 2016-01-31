class DocumentUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "#{Rails.root}/storage/#{model.class.name.pluralize.downcase}"
  end

  def extension_white_list
    %w(pdf)
  end
end
