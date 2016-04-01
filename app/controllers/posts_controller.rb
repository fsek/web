# encoding: UTF-8
class PostsController < ApplicationController
  load_permissions_and_authorize_resource

  def display
    @post = Post.includes(:council).find(params[:id])
    @election = Election.current
    render
  end

  def collapse
    render
  end
end
