# encoding:UTF-8
class MenusController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    @menues = Menu.all
  end

  def new
  end

  def edit
  end

  def create
    if @menu.save
      redirect_to menus_path, notice: alert_create(Menu)
    else
      render action: :new
    end
  end

  def update
    if @menu.update(menu_params)
      redirect_to edit_menu_path(@menu), notice: alert_update(Menu)
    else
      render :edit
    end

  end

  def destroy
    @menu.destroy
    redirect_to menus_url, notice: alert_destroy(Menu)
  end

  private

  def menu_params
    params.require(:menu).permit(:location, :index, :link,
                                 :name, :visible, :turbolinks, :blank_p)
  end
end
