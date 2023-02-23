class Admin::ElectionDocumentsController < Admin::BaseController
    load_permissions_and_authorize_resource

    def create
        params = election_document_params
        params[:document_collection_id] = $parent_document_collection_id
        parent_collection = DocumentCollection.find($parent_document_collection_id)
        @election_document = ElectionDocument.new(params)
        if @election_document.save
            redirect_to(admin_document_collection_path(parent_collection), notice: alert_create(ElectionDocument))
        else
            render :new, status: 422
        end
    end

    def destroy
        parent_collection = DocumentCollection.find($parent_document_collection_id)
        @election_document.destroy!
        redirect_to(admin_document_collection_path(parent_collection), notice: alert_destroy(ElectionDocument))
    end

    def new
        params = new_params
        $parent_document_collection_id = params[:parent_document_collection_id]
    end

    def election_document_params
        params.require(:election_document).permit(:document_name, :url, :document_type, :document_collection_id, :parent_document_collection_id)
    end

    def new_params
        params.permit(:parent_document_collection_id)
    end 
end
