class StartPage
  attr_accessor :news, :events, :notices

  def initialize(member: false)
    @news = News.includes(:translations).
      includes(:user).
      includes(:categories).
      order(created_at: :desc).
      limit(5) || []
    @events = Event.includes(:translations).stream || []
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
