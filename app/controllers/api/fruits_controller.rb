class Api::FruitsController < Api::BaseController
  load_permissions_and_authorize_resource

  def index
    @fruits = Fruit.all
    render json: @fruits,
    each_serializer: Api::FruitSerializer::Index # Returns id, title and author
  end

  def show
    @fruit = Fruit.find(params[:id])
    render json: @fruit,
    serializer: Api::FruitSerializer::Show # Returns all relevant fields
  end
end
