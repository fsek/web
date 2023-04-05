class Api::DocumentCollectionsController < Api::BaseController
    def index
        @collections = DocumentCollection.all
        render json: @collections, each_serializer: Api::DocumentCollectionSerializer::Index
    end

    def show
        @document_collection_id = params[:id]
        @document_collection = DocumentCollection.find(params[:id])
        render json: @document_collection, serializer: Api::DocumentCollectionSerializer::Show
    end
end
  