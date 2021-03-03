class Admin::OrdersController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @orders = initialize_grid(Order.all, order: 'orders.created_at', order_direction: 'desc')
  end

  def show
    @order = Order.find(params[:id])
    @order_items = initialize_grid(@order.order_items)
  end

  def update
    if @order.update(order_params)
      redirect_to(admin_orders_path, notice: alert_update(Order))
    else
      redirect_to(edit_admin_order_path(@order),
                  notice: alert_danger(@order.errors.full_messages))
    end
  end

  def destroy
    @order.destroy!
    redirect_to(admin_orders_path, notice: alert_destroy(Order))
  end

  def package
    @order = Order.find(params[:order_id])

    if @order.update(packaged: !@order.packaged)
      redirect_to(admin_orders_path, notice: alert_update(Order))
    else
      redirect_to(admin_order_path(@order),
                  notice: alert_danger(@order.errors.full_messages))
    end
  end

  def pay
    @order = Order.find(params[:order_id])

    if @order.update(paid: !@order.paid)
      redirect_to(admin_orders_path, notice: alert_update(Order))
    else
      redirect_to(admin_order_path(@order),
                  notice: alert_danger(@order.errors.full_messages))
    end
  end

  private

  def order_params
    params.require(:order).permit(:order_item, :user, :complete)
  end
end
