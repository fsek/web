class Admin::MenusController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @menus_grid = initialize_grid(Menu,
                                  include: [main_menu: :translations],
                                  locale: :sv,
                                  order: 'menus.main_menu_id',
                                  order_direction: 'asc')
  end

  def new
    @menu = Menu.new
  end

  def edit
    @menu = Menu.find(params[:id])
  end

  def create
    @menu = Menu.new(menu_params)
    if @menu.save
      recache_menu
      redirect_to admin_menus_path, notice: alert_create(Menu)
    else
      render :new, status: 422
    end
  end

  def update
    @menu = Menu.find(params[:id])
    if @menu.update(menu_params)
      recache_menu
      redirect_to edit_admin_menu_path(@menu), notice: alert_update(Menu)
    else
      render :edit, status: 422
    end
  end

  def destroy
    menu = Menu.find(params[:id])
    menu.destroy!
    recache_menu

    redirect_to admin_menus_path, notice: alert_destroy(Menu)
  end

  private

  def menu_params
    params.require(:menu).permit(:main_menu_id, :index, :link, :column,
                                 :name_sv, :name_en, :visible, :turbolinks, :blank_p, :header)
  end
end
