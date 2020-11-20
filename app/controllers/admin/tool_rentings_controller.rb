class Admin::ToolRentingsController < Admin::BaseController
  load_permissions_and_authorize_resource

  def create
    @rent = ToolRenting.new(tool_renting_params)
    @rent.tool = Tool.find(params[:tool_id])
    if @rent.save
      ToolRentingService.schedule_reminder(@rent)
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
  end

  def update
    rent = ToolRenting.includes(:tool).find(params[:id])
    if rent.update(tool_renting_params)
      ToolRentingService.remove_reminder(rent)
      ToolRentingService.schedule_reminder(rent)
      redirect_to admin_tool_path(rent.tool), notice: alert_update(ToolRenting)
    else
      render :edit, status: 422
    end
  end

  def destroy
    rent = ToolRenting.includes(:tool).find(params[:id])
    tool = rent.tool

    rent.destroy!
    redirect_to admin_tool_path(tool), notice: alert_destroy(ToolRenting)
  end

  private

  def tool_renting_params
    params.require(:tool_renting).permit(:user_id, :purpose, :tool, :return_date, :returned)
  end
end
