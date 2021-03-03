class Admin::OrderItemsController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
  	initialize_grid(@order.order_items)
  end

  def new
    @order_item = OrderItem.new
  end

  def create
  	@order_item = OrderItem.new(order_item_params)
  end

  def update
    @order_item.update(order_item_params)
  end

  def destroy
    @order_item.destroy!
  end

  private

  def order_item_params
    params.require(order_item).permit(:shop_item, :order, :amount, :comment)
  end
end
