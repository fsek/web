class CartItemsController < ApplicationController

	def index
		@cart = current_user.cart_items
		@cartGrid = initialize_grid(CartItem.includes(params[:current_user]))
		@orderGrid = initialize_grid(Order.includes(params[:current_user]))
	end

	def create_order
		@cart = current_user.cart_items

		if @cart != []
			@cart = current_user.cart_items
			@order = Order.create!(user_id: @cart.first.user_id)

			@cart.each do |item|
				@shop_item = ShopItem.find(item.shop_item_id)
				@inventory = @inventory = Inventory.where(shop_item_id: @shop_item.id, size: item.size, color: item.color).first
				
				unless @inventory.nil?
					@inventory.update(stock: @inventory.stock-item.amount)
				end
				
				OrderItem.create!(order_id: @order.id, shop_item_id: item.shop_item_id, amount: item.amount, comment: item.comment, size: item.size, color: item.color)

				item.destroy!
			end
			redirect_to(cart_items_path)
		end
	end

	def create
		@cart_item = CartItem.new(cart_items_params)
		@shop_item = ShopItem.find(@cart_item.shop_item_id)
		@inventory = Inventory.where(shop_item_id: @shop_item.id, size: @cart_item.size, color: @cart_item.color).first

		if @inventory.nil?
			redirect_to shop_item_path(@shop_item), notice: alert_danger("Varan finns inte på lager!")
		elsif @inventory.stock < @cart_item.amount
			redirect_to shop_item_path(@shop_item), notice: alert_danger("Varan finns inte på lager!")
		else
			if @cart_item.save
				redirect_to shop_item_path(@shop_item), notice: alert_create(CartItem)
			else 
				redirect_to shop_item_path(@shop_item), notice: alert_danger(@cart_item.errors.full_messages)
			end
		end
	end

	def destroy
		@item = CartItem.find(params[:id])
		@item.destroy!

		redirect_to(cart_items_path)
	end

	private

	def cart_items_params
		params.require(:cart_item).permit(:order_id, :user_id, :shop_item_id, :amount, :comment, :size, :color)
	end
end