class Admin::StoreProductsController < Admin::BaseController
  load_permissions_and_authorize_resource

  def new
    @store_product = StoreProduct.new
  end

  def index
    @store_products = initialize_grid(StoreProduct.all, order: :name)
  end

  def edit
    @store_product = StoreProduct.find(params[:id])
  end

  def create
    @store_product = StoreProduct.new(store_product_params)
    if @store_product.save
      redirect_to admin_store_products_path, notice: alert_create(StoreProduct)
    else
      redirect_to new_admin_store_product_path(@store_product), notice: alert_danger('Kunde inte skapa produkt')
    end
  end

  def update
    @store_product = StoreProduct.find(params[:id])
    if @store_product.update(store_product_params)
      redirect_to admin_store_products_path, notice: alert_update(StoreProduct)
    else
      redirect_to edit_admin_store_product_path(@store_product), notice: alert_danger('Kunde inte uppdatera produkt')
    end
  end

  def destroy
    @store_product = StoreProduct.find(params[:id])
    if @store_product.destroy
      redirect_to admin_store_products_path, notice: alert_destroy(StoreProduct)
    else
      redirect_to edit_admin_store_product_path, notice: alert_danger('Kunde inte förinta produkt')
    end
  end

  private

  def store_product_params
    params.require(:store_product).permit(:name, :price, :image_url, :in_stock)
  end
end
