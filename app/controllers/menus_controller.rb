# encoding:UTF-8
class MenusController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    @menues = Menu.all
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
      redirect_to menus_path, notice: alert_create(Menu)
    else
      render :new, status: 422
    end
  end

  def update
    @menu = Menu.find(params[:id])
    if @menu.update(menu_params)
      redirect_to edit_menu_path(@menu), notice: alert_update(Menu)
    else
      render :edit, status: 422
    end
  end

  def destroy
    @menu = Menu.find(params[:id])
    @menu.destroy
    redirect_to menus_url, notice: alert_destroy(Menu)
  end

  private

  def menu_params
    params.require(:menu).permit(:location, :index, :link,
                                 :name, :visible, :turbolinks, :blank_p)
  end
end
