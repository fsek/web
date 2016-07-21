class Admin::ToolsController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @all_tools = Tool.order(title: :asc)
  end

  def show
    @tool = Tool.find(params[:id])
    @rent = @tool.tool_rentings.where(returned: false)
  end

  def create
    @tool = Tool.new(tool_params)
    if @tool.save
      redirect_to admin_tools_path, notice: alert_create(Tool)
    else
      render :new, status: 422
    end
  end

  def new
    @tool = Tool.new
  end

  def edit
    @tool = Tool.find(params[:id])
  end

  def update
    @tool = Tool.find(params[:id])
    if @tool.update(tool_params)
      redirect_to admin_tool_path(@tool), notice: alert_update(Tool)
    else
      render :edit, status: 422
    end
  end

  def destroy
    tool = Tool.find(params[:id])

    tool.destroy!
    redirect_to admin_tools_path, notice: alert_destroy(Tool)
  end

  private

  def tool_params
    params.require(:tool).permit(:title, :description, :total)
  end
end
