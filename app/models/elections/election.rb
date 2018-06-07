class Election < ApplicationRecord
  has_many :nominations, dependent: :destroy
  has_many :candidates, dependent: :destroy, inverse_of: :election
  has_many :election_posts, dependent: :destroy
  has_many :extra_posts, class_name: :Post, through: :election_posts, source: :post

  translates(:title, :description, fallbacks_for_empty_translations: true)
  globalize_accessors(locales: [:en, :sv], attributes: [:title, :description])

  validates :url, uniqueness: true,
                  presence: true,
                  format: { with: /\A[a-z0-9_-]+\z/ }

  validates :title, :open, :close_general, :close_all, :semester, presence: true

  def self.current
    order(open: :asc).where(visible: true).first || nil
  end

  def posts
    case semester
    when Post::AUTUMN
      Post.autumn
    when Post::SPRING
      Post.spring
    when Post::OTHER
      extra_posts
    else
      Post.none
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

  # Returns the current posts
  def current_posts
    case state
    when :not_opened, :before_general
      posts
    when :after_general
      posts.not_general
    when :closed
      Post.none
    end
  end

  def searchable_posts
    if state == :before_general || state == :after_general
      current_posts
    else
      Post.none
    end
  end

  def after_posts
    state == :after_general ? posts.general : Post.none
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

  def post_closing(post)
    if post.elected_by == Post::GENERAL
      close_general
    else
      close_all
    end
  end

  def post_count
    candidates.joins(:post).group('posts.id').size.to_h
  end

  def to_param
    (url.present?) ? url : id
  end

  def to_s
    title || id
  end
end
