class ElectionView
  attr_reader :election
  attr_accessor :grid, :rest_grid, :user, :nomination

  def initialize(election)
    @election = election
  end

  def countdown
    case @election.state
    when :before
      @election.start
    when :during
      @election.end
    when :after
      @election.closing
    end
  end

  def countdown_text
    case @election.state
    when :before
      I18n.t('election_view.opens_in')
    when :during
      I18n.t('election_view.closes_in')
    when :closed
      I18n.t('election_view.already_closed')
    end
  end

  def posts_text
    case @election.state
    when :before
      I18n.t('election_view.posts_will_candidate')
    when :during, :after
      I18n.t('election_view.posts_can_candidate')
    when :closed
      I18n.t('election_view.posts_cannot_candidate')
    end
  end

  def rest_posts_text
    if @election.state == :after
      I18n.t('election_view.posts_cannot_candidate')
    end
  end
end
