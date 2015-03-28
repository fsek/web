# encoding:UTF-8
class CouncilsController < ApplicationController
  load_resource find_by: :url # will use find_by_url!(params[:id])
  authorize_resource
  before_action :set_page, only: :show
  before_action :set_councils

  def index
  end

  def show
    if @page
      @mainelements = @page.page_elements.where(visible: true,
                                                sidebar: false).order(:displayIndex, :asc)
      @sidebarelements = @page.page_elements.where(visible: true,
                                                   sidebar: true).order(:displayIndex, :asc)
    end
    @poster = @council.posts
  end

  def new
    @council = Council.new
  end

  def edit
    @contact = Contact.where(council_id: @council.id).first
  end

  def create
    @council = Council.new(council_params)
    if @council.save
      @council.build_page!(council_id: @council.id)
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
    params.require(:council).permit(:title, :url, :description, :president, :vicepresident, :public)
  end
end
