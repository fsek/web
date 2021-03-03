class Admin::ShopItemsController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @shop_items = initialize_grid(ShopItem.all)
  end

  def new
    @shop_item = ShopItem.new
  end

  def create
    @shop_item = ShopItem.new(shop_item_params)
    if @shop_item.save
      redirect_to admin_shop_items_path, notice: alert_create(ShopItem)
    else
      redirect_to admin_shop_items_path, notice: alert_danger(@shop_item.errors.full_messages)
    end
  end

  def update
    @shop_item = ShopItem.find(params[:id])
    if @shop_item.update(shop_item_params)
      redirect_to(edit_admin_shop_item_path(@shop_item), notice: alert_update(ShopItem))
    else
      redirect_to(edit_admin_shop_item_path(@shop_item),
                  notice: alert_danger(@shop_item.errors.full_messages))
    end
  end

  def destroy
    @shop_item.destroy!
    redirect_to(admin_shop_items_path, notice: alert_destroy(ShopItem))
  end

  private

  def shop_item_params
    params.require(:shop_item).permit(:name, :description, :price, :avatar, colors: [], sizes: [])
  end
end
