class StartPage
  attr_accessor :news, :events, :notices, :election_view, :pinned

  def initialize(member: false)
    @pinned = News.for_feed.pinned || []
    @news = News.for_feed.unpinned.limit(5) || []
    @events = Event.by_locale(locale: I18n.locale).stream || []

    election = Election.current
    if(election.present? && election.state != :closed)
      @election_view = ElectionView.new(election)
    end
  end
end
