class PageElementsController < ApplicationController
  before_action :set_page_element, only: [:show, :edit, :update, :destroy]
  before_action :set_council

  # GET /page_elements
  # GET /page_elements.json
  def index
    @page_elements = @page.page_elements
    if (@page)
      @mainelements = @page.page_elements.where(visible: true,sidebar: false)
      @sidebarelements = @page.page_elements.where(visible:true,sidebar: true)
    end
    if(@mainelemnents) && (@mainelements.count > 1)
      @mainelements = @mainelements.sort_by{ |x| x[:displayIndex]}
    end
    @poster = @council.posts
    @rest = @page.page_elements.where(visible: false)
  end

  # GET /page_elements/1
  # GET /page_elements/1.json
  def show
  end

  # GET /page_elements/new
  def new
    @page_element = PageElement.new()
    @path = council_page_page_elements_path(@council)
  end

  # GET /page_elements/1/edit
  def edit
    
    @path = council_page_page_element_path(@council,@page_element)
  end

  # POST /page_elements
  # POST /page_elements.json
  def create
    @page_element = @page.page_elements.build(page_element_params)

    respond_to do |format|
      if @page_element.save
        format.html { redirect_to council_page_page_elements_path(@council), notice: 'Elementet skapades.' }
        format.json { render action: 'show', status: :created, location: @page_element }
      else
        format.html { render action: 'new' }
        format.json { render json: @page_element.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /page_elements/1
  # PATCH/PUT /page_elements/1.json
  def update
    respond_to do |format|
      if @page_element.update(page_element_params)
        format.html { redirect_to council_page_page_elements_path(@council), notice: 'Elementet uppdaterades.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @page_element.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /page_elements/1
  # DELETE /page_elements/1.json
  def destroy
    @page_element.destroy
    respond_to do |format|
      format.html { redirect_to council_page_page_elements_path(@council) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page_element
      @page_element = PageElement.find(params[:id])      
    end    
    def set_council
      @council = Council.find_by_url(params[:council_id])
      @page = @council.page
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_element_params      
      params.fetch(:page_element).permit(:page_id,:displayIndex, :sidebar, :visible,:text, :headline, :border, :name, :pictureR,:picture)
    end
end
