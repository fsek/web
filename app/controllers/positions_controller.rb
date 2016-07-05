# encoding: UTF-8
class PositionsController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :set_election

  def show
    @position = @election.positions.includes(:council).find(params[:id])
  end

  def modal
    @position = @election.positions.includes(:council).find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def set_election
    @election = Election.current
    if @election.nil?
      render '/elections/no_election', status: 404
    else
      @election
    end
  end
end
