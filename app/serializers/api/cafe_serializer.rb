class Api::CafeSerializer < ActiveModel::Serializer
  
  class Api::CafeSerializer::Index < ActiveModel::Serializer
    attributes(:id, :start, :pass)
  end
end
