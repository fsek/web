class Api::AlbumSerializer < ActiveModel::Serializer
  class Api::AlbumSerializer::Index < ActiveModel::Serializer
    attributes(:id, :title, :start_date, :location, :thumb)
    has_many :years

    def thumb
      Image.first.thumb
    end

    def years
      Album.unique_years
    end
  end

  class Api::AlbumSerializer::Show < ActiveModel::Serializer
    attributes(:id, :translations, :images, :photographers)
    has_many :images

    def photographers
      Image.first.photographer_name
    end

    class Api::ImageSerializer < ActiveModel::Serializer
      attribute(:id)
    end
  end
end
