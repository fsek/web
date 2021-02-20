class Api::FruitSerializer < ActiveModel::Serializer

  class Api::FruitSerializer::Index < ActiveModel::Serializer
    attributes(:id, :name, :is_moldy)

    has_one :user

    class Api::UserSerializer < ActiveModel::Serializer
      attributes(:id, :firstname, :lastname)
    end
  end

  class Api::FruitSerializer::Show < ActiveModel::Serializer
    attributes(:id, :name, :user, :is_moldy)
  end
end