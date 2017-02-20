class AvatarUploader < BaseImageUploader
  storage :file

  def crop
    if model.crop_x.present?
      manipulate! do |img|
        x = model.crop_x.to_i
        y = model.crop_y.to_i
        w = model.crop_w.to_i
        h = model.crop_h.to_i
        img.crop("#{w}x#{h}+#{x}+#{y}")
        img
      end
    end
  end

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
    process resize_to_fit: [800, 10000]
    process :crop
    process resize_to_fill: [350, 350]

    def store_dir
      %(uploads/#{model.class.name.pluralize.downcase}/#{model.id})
    end
  end
end
