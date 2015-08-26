class SquadsController < ApplicationController
  load_permissions_and_authorize_resource

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @squad.save
      redirect_to squad_path(@squad), notice: alert_create(Squad)
    else
      render :new
    end
  end

  def update
    if @squad.update(squad_params)
      redirect_to squad_path(@squad), notice: alert_update(Squad)
    else
      render :edit
    end
  end

  def destroy
    @squad.destroy
    redirect_to squads_url, notice: alert_destroy(Squad)
  end

  private

  def squad_params
    params.require(:squad).permit(:title, :category,
                                  :description, :public)
  end
end
