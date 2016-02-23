class ElectionsController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    election = Election.current

    if election.present?
      @election_view = ElectionView.new(election)
      @election_view.grid = initialize_grid(election.current_posts)
      if election.state == :after && election.after_posts.present?
        @election_view.rest_grid = initialize_grid(election.after_posts,
                                                   name: 'rest',
                                                   include: :council,
                                                   order: 'title')
      end
    else
      render '/elections/no_election', status: 422
    end
  end
end
