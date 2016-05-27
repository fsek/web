class Admin::ToolRentingsController < Admin::BaseController
  load_permissions_and_authorize_resource

  def create
    @rent = ToolRenting.new(tool_renting_params)
    @rent.tool = Tool.find(params[:tool_id])
    if @rent.save
      redirect_to admin_tool_path(@rent.tool), notice: alert_create(ToolRenting)
    else
      render :new, status: 422
    end
  end

  def new
    @rent = ToolRenting.new
    @rent.tool = Tool.find(params[:tool_id])
  end

  def edit
    @rent = ToolRenting.includes(:tool).find(params[:id])
    if @rent.returned
      redirect_to admin_tool_path(@rent.tool), alert: t('model.tool_renting.already_returned')
    end
  end

  def update
    rent = ToolRenting.includes(:tool).find(params[:id])
    if rent.update(tool_renting_params)
      redirect_to admin_tool_path(rent.tool), notice: alert_update(ToolRenting)
    else
      render :edit, status: 422
    end
  end

  def destroy
    rent = ToolRenting.includes(:tool).find(params[:id])
    tool = rent.tool

    rent.destroy!
    redirect_to admin_tool_path(tool), notice: alert_destroy(Tool)
  end

  private

  def tool_renting_params
    params.require(:tool_renting).permit(:renter, :purpose, :tool, :return_date, :returned)
  end
end
