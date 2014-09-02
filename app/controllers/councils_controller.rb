class CouncilsController < ApplicationController
  before_action :set_council, only: [:show, :edit, :update, :destroy]

  # GET /councils
  # GET /councils.json
  def index
    @councils = Council.all
  end

  # GET /councils/1
  # GET /councils/1.json
  def show
  end

  # GET /councils/new
  def new
    @council = Council.new
  end

  # GET /councils/1/edit
  def edit
  end

  # POST /councils
  # POST /councils.json
  def create
    @council = Council.new(council_params)

    respond_to do |format|
      if @council.save
        format.html { redirect_to @council, notice: 'Utskott skapades, success.' }
        format.json { render action: 'show', status: :created, location: @council }
      else
        format.html { render action: 'new' }
        format.json { render json: @council.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /councils/1
  # PATCH/PUT /councils/1.json
  def update
    respond_to do |format|
      if @council.update(council_params)
        format.html { redirect_to @council, notice: 'Utskott uppdaterades!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @council.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /councils/1
  # DELETE /councils/1.json
  def destroy
    @council.destroy
    respond_to do |format|
      format.html { redirect_to councils_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_council
      @council = Council.find_by_url(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def council_params
      params.require(:council).permit(:title,:url,:description,:president,:vicepresident,:epost,:public)
    end
end
