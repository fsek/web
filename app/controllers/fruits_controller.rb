class FruitsController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    @fruits = initialize_grid(current_user.fruits)
  end

  def show
  	@fruit = Fruit.find(params[:id])
  end
end
