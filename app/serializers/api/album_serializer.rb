class Api::AlbumSerializer < ActiveModel::Serializer
  class Api::AlbumSerializer::Index < ActiveModel::Serializer
    attributes(:id, :title, :start_date, :location, :image_count, :thumb, :years)

    def image_count
      object.images_count
    end

    def thumb
      object.images.sample.try(:thumb)
    end

    def years
      Album.unique_years
    end
  end

  class Api::AlbumSerializer::Show < ActiveModel::Serializer
    attributes(:id, :translations, :images, :photographers)

    def photographers
      names = AlbumQueries.photographer_names(object).map { |p| "#{p.firstname} #{p.lastname}" }
      (names + object.photographer_names).uniq
    end
  end
end
