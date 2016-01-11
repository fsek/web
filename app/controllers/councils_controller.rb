# encoding:UTF-8
class CouncilsController < ApplicationController
  load_permissions_and_authorize_resource find_by: :url
  load_and_authorize_resource :post, through: :council
  before_action :set_page, only: [:show, :edit]
  before_action :set_councils

  def index
  end

  def show
    @poster = @council.posts
  end

  def new
  end

  def edit
  end

  def create
    if @council.save
      redirect_to edit_council_path(@council), notice: alert_create(Council)
    else
      render :new, status: 422
    end
  end

  def update
    if @council.update(council_params)
      redirect_to edit_council_path(@council), notice: alert_update(Council)
    else
      render :edit, status: 422
    end
  end

  def destroy
    @council.destroy
    redirect_to councils_url, notice: alert_destroy(Council)
  end

  private

  def set_page
    @page = @council.page
  end

  def set_councils
    @councils = Council.titles
  end

  def council_params
    params.require(:council).permit(:title, :url, :description,
                                    :president, :vicepresident, :public)
  end
end
