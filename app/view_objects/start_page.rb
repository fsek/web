class StartPage
  attr_accessor :news, :events, :notices

  def initialize(member: false)
    @news = News.include_for_feed.by_date.limit(5) || []
    @events = Event.by_locale(locale: I18n.locale).stream || []
    @notices = get_notices(member)
  end

  private

  def get_notices(member)
    if member
      Notice.includes(:translations).published
    else
      Notice.includes(:translations).publik.published
    end
  end
end
