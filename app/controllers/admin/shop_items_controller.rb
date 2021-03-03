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
    if @access_user.save
      redirect_to admin_access_users_path, notice: alert_create(AccessUser)
    else
      redirect_to setup_admin_doors_path, notice: alert_danger(@access_user.errors.full_messages)
    end
  end

  def update
    if @access_user.update(access_user_params)
      redirect_to(admin_access_users_path, notice: alert_update(AccessUser))
    else
      redirect_to(edit_admin_access_user_path(@access_user),
                  notice: alert_danger(@access_user.errors.full_messages))
    end
  end

  def destroy
    @shop_item.destroy!
    redirect_to(admin_shop_items_path, notice: alert_destroy(ShopItem))
  end

  private

  def shop_item_params
    params.require(:shop_item).permit(:name, :description, :price, :image_url)
  end
end
