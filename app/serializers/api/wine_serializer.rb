class Api::WineSerializer < ActiveModel::Serializer
  class Api::WineSerializer::Index < ActiveModel::Serializer
    attributes(:id, :name, :year, :grape)
  end
end
