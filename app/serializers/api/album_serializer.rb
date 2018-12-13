class Api::AlbumSerializer < ActiveModel::Serializer
  class Api::AlbumSerializer::Index < ActiveModel::Serializer
    attributes(:id, :start_date, :location, :image_count, :thumb, :years)
    attribute(:title) { object.title_sv }

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
    attributes(:id, :images, :photographers)
    attribute(:title) { object.title_sv }
    attribute(:description) { object.description_sv }

    def photographers
      names = AlbumQueries.photographer_names(object).map { |p| "#{p.firstname} #{p.lastname}" }
      (names + object.photographer_names).uniq
    end
  end
end
