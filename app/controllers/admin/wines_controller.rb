class Admin::WinesController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @wines = Wine.all
  end

  def new
    @wine = Wine.new
  end

  def create
    @wine = Wine.new(wine_params)
    if @wine.save
      redirect_to admin_wines_path
    else
      render 'new'
    end
  end

  def destroy
    @wine = Wine.find(params[:id])
    @wine.destroy!
  end

  private

  def wine_params
    params.require(:wine).permit(:name, :description, :grape, :year, :alcohol)
  end
end
