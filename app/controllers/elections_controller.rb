class ElectionsController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    election = Election.current

    if election.present?
      @election_view = ElectionView.new(election)
      @election_view.grid = initialize_grid(election.current_posts,
                                            name: :main,
                                            per_page: 50,
                                            locale: I18n.locale,
                                            include: [council: :translations],
                                            order: 'post_translations.title')
      @count = election.post_count

      if election.after_posts.any?
        @election_view.rest_grid = initialize_grid(election.after_posts,
                                                   name: :rest,
                                                   per_page: 50,
                                                   locale: I18n.locale,
                                                   include: [council: :translations],
                                                   order: 'post_translations.title')
      end
    else
      render '/elections/no_election'
    end
  end
end
