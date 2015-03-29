class ConstantsController < ApplicationController
  load_permissions_and_authorize_resource

  before_action :set_constant, only: [:show, :edit, :update, :destroy]

  # GET /constants
  def index
    @constants = Constant.all
  end

  # GET /constants/1
  def show
  end

  # GET /constants/new
  def new
    @constant = Constant.new
  end

  # GET /constants/1/edit
  def edit
  end

  # POST /constants
  def create
    @constant = Constant.new(constant_params)
    if @constant.save
      redirect_to @constant, notice: 'Constant was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /constants/1
  def update
    if @constant.update(constant_params)
      redirect_to @constant, notice: 'Constant was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /constants/1
  def destroy
    @constant.destroy
    redirect_to constants_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_constant
    @constant = Constant.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def constant_params
    params.require(:constant).permit(:name, :value)
  end
end
