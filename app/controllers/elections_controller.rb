class ElectionsController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    election = Election.current

    if election.present?
      @election_view = ElectionView.new(election)
      @election_view.grid = initialize_grid(election.current_posts,
                                            include: :council,
                                            name: :main)
      @count = election.post_count

      if election.after_posts.any?
        @election_view.rest_grid = initialize_grid(election.after_posts,
                                                   include: :council,
                                                   name: :rest)
      end
    else
      render '/elections/no_election'
    end
  end
end
