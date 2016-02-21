# encoding:UTF-8
class ElectionsController < ApplicationController
  before_action :set_election
  load_permissions_and_authorize_resource

  def index
    if @election.instance_of?(Election)
      @grid_election = initialize_grid(@election.current_posts, name: 'election')
      @grid_termins = initialize_grid(@election.posts.general, name: 'election')
    else
      @election = nil
    end
  end

  private

  def set_election
    @election = Election.current
  end
end
