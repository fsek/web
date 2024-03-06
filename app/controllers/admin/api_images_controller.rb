class Admin::ApiImagesController < Admin::BaseController
    load_permissions_and_authorize_resource

    def index
        @api_images = initialize_grid(ApiImage)
    end

    def show
        @api_image_id = params[:id]
        @documents = initialize_grid(ElectionDocument.where(document_collection_id: params[:id]))
    end

    def destroy
        @api_image.destroy!
        redirect_to(admin_api_images_path, notice: alert_destroy(ApiImage))
    end

    def create
        @api_image = ApiImage.new(api_image_params)
        if @api_image.save
            redirect_to(admin_api_image_path, notice: alert_create(ApiImage))
        else
            render :new, status: 422
        end
    end

    def api_image_params
        params.require(:api_image).permit(:filename, :file)
    end
end
