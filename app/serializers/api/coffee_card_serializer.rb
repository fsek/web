class Api::CoffeeCardSerializer < ActiveModel::Serializer

    class Api::CoffeeCardSerializer::Index < ActiveModel::Serializer
      attributes(:id, :available_coffees)
  
      has_one :user
  
      class Api::UserSerializer < ActiveModel::Serializer
        attributes(:id, :firstname, :lastname)
      end
    end
  
    class Api::CoffeeCardSerializer::Show < ActiveModel::Serializer
      attributes(:id, :user, :available_coffees)
    end
  end