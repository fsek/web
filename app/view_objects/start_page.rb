class StartPage
  attr_accessor :news, :events, :notices

  def initialize(member: false)
    @news = News.order(created_at: :desc).limit(5).includes(:user) || []
    @events = Event.stream || []
    @notices = get_notices(member) || []
  end

  private

  def get_notices(member)
    if member
      Notice.published
    else
      Notice.publik.published
    end
  end
end
