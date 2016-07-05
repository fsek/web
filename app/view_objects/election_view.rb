class ElectionView
  attr_reader :election, :position_count
  attr_accessor :rest_grid, :grid, :candidate, :user, :nomination

  def initialize(election, candidate: nil)
    @election = election
    @candidate = candidate
  end

  def countdown_text
    case @election.state
    when :not_opened
      I18n.t('election_view.opens_in')
    when :before_general, :after_general
      I18n.t('election_view.closes_in')
    when :closed
      I18n.t('election_view.already_closed')
    end
  end

  def positions_text
    case @election.state
    when :not_opened
      I18n.t('election_view.positions_will_candidate')
    when :before_general, :after_general
      I18n.t('election_view.positions_can_candidate')
    when :closed
      I18n.t('election_view.positions_cannot_candidate')
    end
  end

  def rest_positions_text
    if @election.state == :after_general
      I18n.t('election_view.positions_cannot_candidate')
    end
  end

  def position_closing
    if candidate.present? && candidate.position.present?
      election.position_closing(candidate.position)
    end
  end

  def position_count
    @position_count ||= election.position_count
  end
end
