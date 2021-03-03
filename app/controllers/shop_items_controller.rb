class ShopItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @shop_items = ShopItem.all
  end

  def show
  	@shop_item = ShopItem.find(params[:id])
  	@cart_item = CartItem.new 
  end

  def shop_items_params
		params.require(:shop_item).permit(:order, :shop_item, :amount, :comment, :avatar, colors: [], sizes: [])
	end
end