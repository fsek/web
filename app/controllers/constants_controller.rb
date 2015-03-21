class ConstantsController < ApplicationController
  load_and_authorize_resource

  def index
    @constants = Constant.all
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @constant.save!
    redirect_to @constant
  end

  def update
    @constant.update! constant_params
    redirect_to @constant
  end

  def destroy
    @constant.destroy!
    redirect_to Constant
  end

  private
  def constant_params
    params.require(:constant).permit(
      :name, :value,
    )
  end
end
