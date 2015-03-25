class ConsoleController < ApplicationController
  before_filter :verify_admin
  def index
    console
  end
end
