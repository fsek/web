class Api::ElectionDocumentSerializer < ActiveModel::Serializer
    class Api::ElectionDocumentSerializer::Index < ActiveModel::Serializer
        attributes(:id, :document_name, :document_type, :url, :reference)
    end
end
  