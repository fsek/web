class Admin::MainMenusController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @grid = initialize_grid(MainMenu, locale: :sv)
  end

  def new
    @main_menu = MainMenu.new
  end

  def edit
    @main_menu = MainMenu.find(params[:id])
  end

  def create
    @main_menu = MainMenu.new(main_menu_params)
    if @main_menu.save
      recache_menu
      redirect_to admin_main_menus_path, notice: alert_create(MainMenu)
    else
      render :new, status: 422
    end
  end

  def update
    @main_menu = MainMenu.find(params[:id])
    if @main_menu.update(main_menu_params)
      recache_menu
      redirect_to edit_admin_main_menu_path(@main_menu), notice: alert_update(MainMenu)
    else
      render :edit, status: 422
    end
  end

  def destroy
    main_menu = MainMenu.find(params[:id])
    main_menu.destroy!
    recache_menu

    redirect_to admin_main_menus_path, notice: alert_destroy(MainMenu)
  end

  private

  def main_menu_params
    params.require(:main_menu).permit(:name_sv, :name_en, :index, :mega, :fw, :visible)
  end
end
