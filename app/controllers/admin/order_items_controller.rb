class Admin::OrderItemsController < Admin::BaseController
  load_permissions_and_authorize_resource

  private

  def order_params
    params.require(:order_item).permit(:order, :shop_item, :amount, :comment)
  end
end
