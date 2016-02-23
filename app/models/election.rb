# encoding: UTF-8
class Election < ActiveRecord::Base
  has_many :nominations, dependent: :destroy
  has_many :candidates, dependent: :destroy
  has_and_belongs_to_many :posts

  validates :url, uniqueness: true,
                  presence: true,
                  format: { with: /\A[a-z0-9_-]+\z/ }

  validates :start, :end, :closing, presence: true

  def self.current
    self.order(start: :asc).where(visible: true).first || nil
  end

  def termin_grid
    if (p = posts.termins).count > 0
      initialize_grid(p, name: 'election')
    end
  end

  def rest_grid
    if (p = posts.not_termins).count > 0
      initialize_grid(p, name: 'election')
    end
  end

  # Returns current status
  def state
    t = Time.zone.now
    if t < start
      return :before
    elsif t >= start && t < self.end
      return :during
    elsif t < closing
      return :after
    else
      return :closed
    end
  end

  # Returns the current posts
  def current_posts
    if state == :after
      posts.title.not_termins
    else
      posts.title
    end
  end

  # Returns the start_date if before, the end_date if during and none if after.
  def countdown
    case state
    when :before
      start
    when :during
      self.end
    when :after
      closing || nil
    end
  end

  def post_closing(post)
    if post.present?
      if post.elected_by == Post::GENERAL
        self.end
      else
        closing
      end
    end
  end

  def candidate_count(post)
    if post.present?
      candidates.where(post_id: post.id).count
    else
      0
    end
  end

  def can_candidate?(post)
    if post.elected_by == Post::GENERAL && state == :during
      return true
    elsif post.elected_by != Post::GENERAL && state != :before
      return true
    end

    false
  end

  def to_param
    (url.present?) ? url : id
  end

  def to_s
    title || url
  end
end
