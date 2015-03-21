# encoding:UTF-8
class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  # GET /pages
  # GET /pages.json
  def index
    @pages = @page.page_elements
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    if @page
      @mainelements = @page.page_elements.where(visible: true, sidebar: false)
      @sidebarelements = @page.page_elements.where(visible: true, sidebar: true)
    end
    if (@mainelemnents) && (@mainelements.count > 1)
      @mainelements = @mainelements.sort_by { |x| x[:displayIndex] }
    end
    @poster = @council.posts
  end

  # GET /pages/new
  def new
    @page = Page.new
  end

  # GET /pages/1/edit
  def edit
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, notice: 'Sidan skapades, success!.' }
        format.json { render action: 'show', status: :created, location: @page }
      else
        format.html { render action: 'new' }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def update
    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to @page, notice: 'Sidan uppdaterades, great!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to pages_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_page
    @council = Council.find_by_url(params[:council_id])
    @page = @council.page
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def page_params
    params.fetch(:page).permit(:council_id)
  end
end
