class Api::StoreProductsController < Api::BaseController
  load_permissions_and_authorize_resource

  def index
    @store_products = StoreProduct.all
    render json: @store_products, each_serializer: Api::StoreProductSerializer::Index
  end
end
