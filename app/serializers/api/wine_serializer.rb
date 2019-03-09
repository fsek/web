class Api::WineSerializer < ActiveModel::Serializer
  attributes(:name, :year, :grape, :description)
  belongs_to :grape

  class Api::GrapeSerializer < ActiveModel::Serializer
    attributes(:name, :color)
  end
end
