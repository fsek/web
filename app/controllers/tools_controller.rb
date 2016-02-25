class ToolsController < ApplicationController

  def index
    @all_tools = Tool.all
  end

  def new
    @tool = Tool.new
  end

  def create
    @tool = Tool.new(tools_params)
    if @tool.save
      redirect_to tools_path, notice: alert_create(Tool)
    else
      render 'new', status: 422
    end
  end

  def tools_params
    params.require(:tool).permit(:title, :description)
  end


end
