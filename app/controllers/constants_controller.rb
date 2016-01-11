class ConstantsController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :set_constant, only: [:show, :edit, :update, :destroy]

  def index
    @constants = Constant.all
  end

  def show
  end

  def new
    @constant = Constant.new
  end

  def edit
  end

  def create
    @constant = Constant.new(constant_params)
    if @constant.save
      redirect_to @constant, notice: alert_create(Constant)
    else
      render :new, status: 422
    end
  end

  def update
    if @constant.update(constant_params)
      redirect_to @constant, notice: alert_update(Constant)
    else
      render :edit, status: 422
    end
  end

  def destroy
    @constant.destroy!
    redirect_to constants_url
  end

  private

  def set_constant
    @constant = Constant.find(params[:id])
  end

  def constant_params
    params.require(:constant).permit(:name, :value)
  end
end
