class Admin::OrdersController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @active_orders = initialize_grid(Order.find_by(complete: false))
    @inactive_orders = initialize_grid(Order.find_by(complete: true))
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
    redirect_to(admin_order_path, notice: alert_destroy(Order))
  end

  private

  def order_params
    params.require(:order).permit(:order_item, :user, :complete)
  end
end
