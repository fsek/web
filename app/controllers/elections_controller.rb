class ElectionsController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    election = Election.current

    if election.present?
      @election_view = ElectionView.new(election)
      @election_view.grid = initialize_grid(election.posts)
    else
      render '/elections/no_election', status: 422
    end
  end
end
