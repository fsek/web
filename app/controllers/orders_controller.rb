class OrdersController < ApplicationController
	def show
		@order = Order.find(params[:id])
		@order_items = initialize_grid(OrderItem.where(order_id: @order.id))
	end

	def destroy
		@order = Order.find(params[:id])
    @items = OrderItem.where(order_id: @order.id)

    @items.each do |item|
      @inventory = @inventory = Inventory.where(shop_item_id: item.shop_item_id, size: item.size, color: item.color).first
      
      unless @inventory.nil?
        @inventory.update(stock: @inventory.stock+item.amount)
      end
    end

    @order.destroy!
    redirect_to(cart_items_path, notice: alert_destroy(Order))
  end

  private

  def order_params
  	params.require(:order).permit(:complete, :user, :order_items)
  end
end