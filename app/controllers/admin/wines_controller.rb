class Admin::WinesController < Admin::BaseController
  load_permissions_and_authorize_resource

  def new
  end

  def index
    @wines = initialize_grid(Wine.all)
  end

  def create
    @wine = Wine.new(wine_params)
    if @wine.save
      redirect_to admin_wines_path, notice: alert_create(Wine)
    else
      redirect_to new_admin_wine_path(@wine), notice: alert_danger('Kunde inte skapa vinet')
    end
  end

  def destroy
    @wine = Wine.find(params[:id])
    if @wine.destroy
        redirect_to admin_wines_path, notice: alert_destroy(Wine)
    else
        redirect_to admin_wines_path, notice: alert_destroy(Wine)
    end
  end

  private

  def wine_params
    params.require(:wine).permit(:name, :year, :grape)
  end
end
