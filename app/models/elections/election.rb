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

  validates :title, :open, :close_in_between, :close_general, :close_all, :semester, presence: true

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
    elsif t < close_in_between
      return :before_in_between
    elsif  t < close_all
      return :after_general_and_in_between
    else
      return :closed
    end
  end

  # Returns the current posts
  def current_posts
    case state
    when :not_opened, :before_general
      res = posts
    when :before_in_between
      res = posts.not_general
    when :after_general_and_in_between
      res = posts.not_in_between
    when :closed
      res = Post.none
    end

    if has_extra_now
      post_union(res, extra_posts)
    else
      res
    end
  end

  def searchable_posts
    if state == :before_general || state == :before_in_between || state == :after_general_and_in_between || has_extra_now
      current_posts
    else
      Post.none
    end
  end

  def after_posts
    case state
    when :before_in_between
      res = posts.general
    when :after_general_and_in_between
      res = posts.general_and_in_between
    when :closed
      res = posts
    else
      res = Post.none
    end

    # if there is an extra election, and that time has passed
    if close_extra.present? && Time.zone.now > close_extra
      post_union(res, extra_posts)
    else
      res
    end
  end

  # Returns whether or not the current election has extra posts that currently are possible to candidate to
  def has_extra_now
    close_extra.present? && Time.zone.now < close_extra
  end

  # Returns the start_date if before, the in_between_date if after general, end_date if after that and none if after all elections.
  def countdown
    case state
    when :not_opened
      open
    when :before_general
      close_general
    when :before_in_between
      close_in_between
    when :after_general_and_in_between
      close_all
    end
  end

  def post_closing(post)
    if post.elected_by == Post::GENERAL
      close_general
    elsif post.elected_by == Post::IN_BETWEEN
      close_in_between
    else
      close_all
    end
  end

  def post_count
    candidates.joins(:post).group('posts.id').size.to_h
  end

  # ugly hack to get union in correct type, hopefully not too expensive
  def post_union(posts1, posts2)
    Post.where(id: (posts1 | posts2).map(&:id))
  end

  def to_param
    (url.present?) ? url : id
  end

  def to_s
    title || id
  end
end
