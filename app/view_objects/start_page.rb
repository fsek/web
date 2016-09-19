class StartPage
  attr_accessor :news, :events, :notices
  attr_reader :countdown

  def initialize(member: false)
    @news = News.include_for_feed.by_date.limit(5) || []
    @events = Event.by_locale(locale: I18n.locale).stream || []
    @notices = get_notices(member)
    @countdown = Time.zone.now.change(month: 9, day: 22, hour: 16, minute: 0, second: 0)
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
