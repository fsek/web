# encoding:UTF-8
class CouncilsController < ApplicationController
  load_permissions_and_authorize_resource find_by: :url

  def index
    @councils = Council.titles
  end

  def show
    @council = Council.includes(posts: :users).find_by_url!(params[:id])
  end

  def new
    @council = Council.new
  end

  def edit
    @council = Council.includes(:posts).find_by_url!(params[:id])
  end

  def create
    @council = Council.new(council_params)
    if @council.save
      redirect_to edit_council_path(@council), notice: alert_create(Council)
    else
      render :new, status: 422
    end
  end

  def update
    @council = Council.includes(:posts).find_by_url!(params[:id])
    if @council.update(council_params)
      redirect_to edit_council_path(@council), notice: alert_update(Council)
    else
      render :edit, status: 422
    end
  end

  def destroy
    council = Council.find_by_url!(params[:id])
    council.destroy
    redirect_to councils_url, notice: alert_destroy(Council)
  end

  private

  def council_params
    params.require(:council).permit(:title, :url, :description,
                                    :president, :vicepresident, :public)
  end
end
