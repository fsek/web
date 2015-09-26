class ExLinksController < ApplicationController
  before_action :set_ex_link, only: [:show, :edit, :update, :destroy]

  # GET /ex_links
  # GET /ex_links.json
  def index
    @ex_links = ExLink.all
  end

  # GET /ex_links/1
  # GET /ex_links/1.json
  def show
  end

  # GET /ex_links/new
  def new
    @ex_link = ExLink.new
  end

  # GET /ex_links/1/edit
  def edit
  end

  # POST /ex_links
  # POST /ex_links.json
  def create
    @ex_link = ExLink.new(ex_link_params)
    if @ex_link.save
      redirect_to @ex_link, notice: 'Ex link was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /ex_links/1
  # PATCH/PUT /ex_links/1.json
  def update
    if @ex_link.update(ex_link_params)
      redirect_to @ex_link, notice: 'Ex link was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /ex_links/1
  # DELETE /ex_links/1.json
  def destroy
    @ex_link.destroy
    redirect_to ex_links_url, notice: 'Ex link was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_ex_link
    @ex_link = ExLink.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ex_link_params
    params.require(:ex_link).permit(:label, :url, :tags, :test_availability,
                                    :note, :active, :expiration)
  end
end
