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
      redirect_to menus_path, notice: 'Menyn skapades.'
    else
      render action: :new
    end
  end

  def update
    if @menu.update(menu_params)
      redirect_to edit_menu_path(@menu), notice: 'Menyn uppdaterades.'
    else
      render action: 'edit'
    end

  end

  def destroy
    @menu.destroy
    redirect_to menus_url, notice: 'Menyn raderades'
  end

  private

  def menu_params
    params.require(:menu).permit(:location, :index, :link,
                                 :name, :visible, :turbolinks, :blank_p)
  end
end
