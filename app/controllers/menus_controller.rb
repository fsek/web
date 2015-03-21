# encoding:UTF-8
class MenusController < ApplicationController
  before_filter :authenticate
  before_action :set_menu, only: [:show, :edit, :update, :destroy]

  # GET /menus
  # GET /menus.json
  def index
    @menues = Menu.all
  end

  # GET /menus/new
  def new
    @menu = Menu.new
  end

  # GET /menus/1/edit
  def edit
  end

  # POST /menus
  # POST /menus.json
  def create
    @menu = Menu.new(menu_params)

    respond_to do |format|
      if @menu.save
        format.html { redirect_to menus_path, notice: 'Menyn skapades.' }
        format.json { render action: 'edit', status: :created, location: @menu }
      else
        format.html { render action: 'new' }
        format.json { render json: @menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /menus/1
  # PATCH/PUT /menus/1.json
  def update
    respond_to do |format|
      if @menu.update(menu_params)
        format.html { redirect_to edit_menu_path(@menu), notice: 'Menyn uppdaterades.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /menus/1
  # DELETE /menus/1.json
  def destroy
    @menu.destroy
    respond_to do |format|
      format.html { redirect_to menus_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_menu
    @menu = Menu.find(params[:id])
  end

  def authenticate
    flash[:error] = t('the_role.access_denied')
    redirect_to(:back) unless (current_user) && (current_user.moderator?(:meny))
    rescue ActionController::RedirectBackError
      redirect_to root_path
  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def menu_params
    params.require(:menu).permit(:location, :index, :link, :name, :visible, :turbolinks, :blank_p)
  end
end
