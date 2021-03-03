class Admin::InventoriesController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @shop_items = initialize_grid(ShopItem.all)
    @inventories = initialize_grid(Inventory.all)
  end

  def edit
    @inventory = Inventory.find(params[:id])
    @shop_item = ShopItem.find(@inventory.shop_item_id)
  end

  def update
  	@inventory = Inventory.find(params[:id])

  	if @inventory.update(inventory_params)
  		redirect_to(admin_inventories_path)
  	end
  end

  def new
    @shop_item = ShopItem.find(params[:shop_item_id])
  end

  def create
  	@inventory = Inventory.new(inventory_params)
    @shop_item = ShopItem.find(@inventory.shop_item_id)

  	if @inventory.save
  		redirect_to(admin_inventories_path)
  	else
      redirect_to(admin_inventories_path, alert: "Inventariet existerar redan.")
    end
  end

  private

  def inventory_params
    params.require(:inventory).permit(:stock, :color, :size, :shop_item_id)
  end
end