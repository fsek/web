class ElectionView
  attr_reader :election, :post_count
  attr_accessor :rest_grid, :grid, :candidate, :user, :nomination

  def initialize(election, candidate: nil)
    @election = election
    @candidate = candidate
  end

  def countdown_text
    case @election.state
    when :not_opened
      I18n.t('election_view.opens_in')
    when :before_general
      I18n.t('election_view.general_closes_in')
    when :before_in_between
      I18n.t('election_view.in_between_closes_in')
    when :after_general_and_in_between
      I18n.t('election_view.closes_in')
    when :closed
      I18n.t('election_view.already_closed')
    end
  end

  def posts_text
    if @election.extra_now?
      I18n.t('election_view.posts_can_candidate')
    else
      case @election.state
      when :not_opened
        I18n.t('election_view.posts_will_candidate')
      when :before_general, :before_in_between, :after_general_and_in_between
        I18n.t('election_view.posts_can_candidate')
      when :closed
        I18n.t('election_view.posts_cannot_candidate')
      end
    end
  end

  def rest_posts_text
    if @election.state == :before_in_between || @election.state == :after_general_and_in_between
      I18n.t('election_view.posts_cannot_candidate')
    elsif @election.state == :closed && @election.extra_now?
      I18n.t('election_view.posts_cannot_candidate')
    end
  end

  def post_closing
    if candidate.present? && candidate.post.present?
      election.post_closing(candidate.post)
    end
  end

  def post_count
    @post_count ||= election.post_count
  end
end
