# encoding: UTF-8
class Election < ActiveRecord::Base
  has_many :nominations, dependent: :destroy
  has_many :candidates, dependent: :destroy

  validates :url, uniqueness: true,
                  presence: true,
                  format: { with: /\A[a-z0-9_-]+\z/ }

  validates :title, :start, :stop, :closing, :semester, presence: true

  def self.current
    self.order(start: :asc).where(visible: true).first || nil
  end

  def posts
    if semester == Post::AUTUMN
      Post.autumn
    elsif semester == Post::SPRING
      Post.spring
    else
      Post.none
    end
  end

  def state
    t = Time.zone.now
    if t < start
      return :before
    elsif t >= start && t < stop
      return :during
    elsif t < closing
      return :after
    else
      return :closed
    end
  end

  def post_closing(post)
    if post.elected_by == Post::GENERAL
      stop
    else
      closing
    end
  end

  def candidate_count(post)
    if post.present?
      candidates.where(post_id: post.id).count
    else
      0
    end
  end

  def to_param
    (url.present?) ? url : id
  end

  def to_s
    title || id
  end
end
