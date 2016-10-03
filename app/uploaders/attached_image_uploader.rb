class AttachedImageUploader < BaseImageUploader
  storage :file

  def store_dir
    %(#{Rails.root}/storage/#{model.class.name.pluralize.downcase}/#{model.id})
  end

  version :large do
    process resize_to_fit: [800, 10000]

    def store_dir
      %(uploads/#{model.class.name.pluralize.downcase}/#{model.id})
    end
  end

  version :thumb do
    process resize_to_fill: [350, 350]

    def store_dir
      %(uploads/#{model.class.name.pluralize.downcase}/#{model.id})
    end
  end
end
