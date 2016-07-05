# encoding: UTF-8
class Election < ActiveRecord::Base
  has_many :nominations, dependent: :destroy
  has_many :candidates, dependent: :destroy, inverse_of: :election
  has_many :election_positions, dependent: :destroy
  has_many :extra_positions, class_name: Position,
                             through: :election_positions,
                             source: :position

  validates :url, uniqueness: true,
                  presence: true,
                  format: { with: /\A[a-z0-9-]+\z/ }

  validates :title, :open, :close_general, :close_all, :semester, presence: true

  def self.current
    order(open: :asc).where(visible: true).first || nil
  end

  def positions
    case semester
    when Position::AUTUMN
      Position.autumn.by_title
    when Position::SPRING
      Position.spring.by_title
    when Position::OTHER
      extra_positions.by_title
    else
      Position.none
    end
  end

  def state
    t = Time.zone.now
    if t < open
      return :not_opened
    elsif t >= open && t < close_general
      return :before_general
    elsif t < close_all
      return :after_general
    else
      return :closed
    end
  end

  # Returns the current positions
  def current_positions
    case state
    when :not_opened, :before_general
      positions
    when :after_general
      positions.not_general
    when :closed
      Position.none
    end
  end

  def searchable_positions
    if state == :before_general || state == :after_general
      current_positions
    else
      Position.none
    end
  end

  def after_positions
    state == :after_general ? positions.general : Position.none
  end

  # Returns the start_date if before, the end_date if during and none if after.
  def countdown
    case state
    when :not_opened
      open
    when :before_general
      close_general
    when :after_general
      close_all
    end
  end

  def position_closing(position)
    if position.elected_by == Position::GENERAL
      close_general
    else
      close_all
    end
  end

  def position_count
    candidates.joins(:position).group('positions.id').size.to_h
  end

  def to_param
    (url.present?) ? url : id
  end

  def to_s
    title || id
  end
end
