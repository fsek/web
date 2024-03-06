class Api::ApiImagesController < Api::BaseController
    def index
        @api_images = ApiImage.all
        render json: @images, each_serializer: Api::ApiImageSerializer::Index
    end

    def show
        # @api_image_id = params[:id]
        @api_image = ApiImage.find(params[:id])
        render json: @api_image, serializer: Api::ApiImageSerializer::Show
    end
end

