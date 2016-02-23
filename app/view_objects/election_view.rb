class ElectionView
  attr_reader :election
  attr_accessor :grid, :candidates, :candidate, :user, :nomination

  def initialize(election, candidate: nil, candidates: [])
    @election = election
    @candidate = candidate
    @candidates = candidates
  end

  def countdown
    case @election.state
    when :before
      @election.start
    when :during
      @election.stop
    when :after
      @election.closing
    end
  end

  def countdown_text
    case @election.state
    when :before
      I18n.t('election.opens_in')
    when :during
      I18n.t('election.closes_in')
    else
      nil
    end
  end

  def posts_text
    case @election.state
    when :before
      I18n.t('election.posts_before')
    when :during
      I18n.t('election.posts_during')
    else
      nil
    end
  end
end
