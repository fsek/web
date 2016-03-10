class Admin::ToolsController < ApplicationController
  before_action :authorize

  def index
    @all_tools = Tool.all
  end

  def create
    @tool = Tool.new(tools_params)
    if @tool.save
      redirect_to admin_tools_path, notice: alert_create(Tool)
    else
      render 'new', status: 422
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
    if @tool.update(tools_params)
      redirect_to admin_tools_path, notice: alert_update(Tool)
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
  def tools_params
    params.require(:tool).permit(:title, :description, :total)
  end

  def authorize
    authorize!(:modify, Tool)
  end
end
