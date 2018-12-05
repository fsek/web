class Api::CouncilSerializer < ActiveModel::Serializer
  class Api::CouncilSerializer::Index < ActiveModel::Serializer
    attributes(:id, :title)
  end
end
