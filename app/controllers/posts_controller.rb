# encoding: UTF-8
class PostsController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :set_election

  def show
    @post = @election.posts.includes(:council).find(params[:id])
  end

  def modal
    @post = @election.posts.includes(:council).find(params[:id])
    respond_to do |format|
      format.html { render :show }
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
