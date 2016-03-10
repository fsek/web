class ToolsController < ApplicationController

  def index
    @all_tools = Tool.all
  end
end
