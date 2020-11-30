class FruitsController < ApplicationController

  def index
    @fruits = initialize_grid(current_user.fruits)
  end

  def show
  	@fruit = Fruit.find(params[:id])
  end
end
