class ToolsController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    @all_tools = Tool.order(title: :asc)
  end

  def show
    @tool = Tool.find(params[:id])
    @rent = ToolRenting.where(tool_id: params[:id], returned: false)
  end
end
