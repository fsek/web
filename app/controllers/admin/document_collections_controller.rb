class Admin::DocumentCollectionsController < Admin::BaseController
    load_permissions_and_authorize_resource

    def index
        @document_collections = initialize_grid(DocumentCollection)
    end

    def show
        @document_collection_id = params[:id]
        @documents = initialize_grid(ElectionDocument.where(document_collection_id: params[:id]))
    end

    def destroy
        @document_collection.destroy!
        redirect_to(admin_document_collections_path, notice: alert_destroy(DocumentCollection))
    end

    def create
        @document_collection = DocumentCollection.new(document_collection_params)
        if @document_collection.save
            redirect_to(admin_document_collections_path, notice: alert_create(DocumentCollection))
        else
            render :new, status: 422
        end
    end

    def document_collection_params
        params.require(:document_collection).permit(:collection_name)
    end
end
