class Api::DocumentCollectionSerializer < ActiveModel::Serializer
    class Api::DocumentCollectionSerializer::Index < ActiveModel::Serializer
        attributes(:id, :collection_name)
    end

    class Api::DocumentCollectionSerializer::Show < ActiveModel::Serializer
        has_many :election_documents,
            serializer:  Api::ElectionDocumentSerializer::Index,
            scope: {
                'document_collection_id': @document_collection_id
            }
        attributes(:id, :collection_name, :election_documents)
    end
end
  