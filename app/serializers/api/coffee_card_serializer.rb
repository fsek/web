class Api::CoffeeCardSerializer < ActiveModel::Serializer

    class Api::CoffeeCardSerializer::Index < ActiveModel::Serializer
      attributes(:id, :available_coffees)
    end
  end