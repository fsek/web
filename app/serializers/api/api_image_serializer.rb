class Api::ApiImageSerializer < ActiveModel::Serializer
    class Api::ApiImageSerializer::Index < ActiveModel::Serializer
        attributes(:id, :filename)
    end

    class Api::DocumentCollectionSerializer::Show < ActiveModel::Serializer
        attributes(:id, :filename, :file)
    end
end
