class Api::WineSerializer < ActiveModel::Serializer

  class Api::WineSerializer::Index < ActiveModel::Serializer
    attributes(:name, :year)
  end

  class Api::WineSerializer::Show < ActiveModel::Serializer
    attributes(:name, :year, :country)

    belongs_to :grape

    class Api::GrapeSerializer < ActiveModel::Serializer
      attributes(:name, :color)
    end
  end
end
