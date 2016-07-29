class ElectionsController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    election = Election.current

    if election.present?
      @election_view = ElectionView.new(election)
      @election_view.grid = initialize_grid(election.current_positions,
                                            include: :council,
                                            name: :main)

      if election.after_positions.any?
        @election_view.rest_grid = initialize_grid(election.after_positions,
                                                   include: :council,
                                                   name: :rest)
      end
    else
      render '/elections/no_election', status: 404
    end
  end
end
