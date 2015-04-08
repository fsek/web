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
    @contact = Contact.where(council_id: @council.id).first
  end

  def create
    if @council.save
      redirect_to edit_council_path(@council), notice: 'Utskott skapades, success.'
    else
      render action: 'new'
    end
  end

  def update
    if @council.update(council_params)
      redirect_to edit_council_path(@council), notice: 'Utskott uppdaterades!'
    else
      render action: :edit
    end
  end

  def destroy
    @council.destroy
    redirect_to councils_url, notice: 'Utskottet raderades'
  end

  private

  def set_page
    @page = @council.page
  end

  def set_councils
    @councils = Council.all
  end

  def council_params
    params.require(:council).permit(:title, :url, :description,
                                    :president, :vicepresident, :public)
  end
end
