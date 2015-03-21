# encoding: UTF-8
class Election < ActiveRecord::Base
  has_many :nominations, dependent: :destroy
  has_many :candidates, dependent: :destroy
  has_and_belongs_to_many :posts

  validates_presence_of :url
  validates_uniqueness_of :url

  scope :current, -> { order(start: :asc).where(visible: true).take }

  # Returns a number to load different views
  # 1: before the election opens
  # 2: during the election
  # 3: after the election
  # /d.wessman
  def view_status
    if start > Time.zone.now
      return 1
    elsif (start <= Time.zone.now) && (self.end > Time.zone.now)
      return 2
    else
      return 3
    end
  end

  # Returns a status text depending on the view_status
  # /d.wessman
  def status_text
    i = view_status
    if i == 1
      return text_before
    elsif i == 2
      return text_during
    else
      return text_after
    end
  end

  # Returns a status text for the nominations page
  # /d.wessman
  def nomination_status
    if view_status != 3
      return ''
    end
    'Det går endast att nominera till poster som inte väljs på Terminsmötet'
  end
  # Returns the current posts
  # /d.wessman
  def current_posts
    if view_status != 3
      posts
    else
      posts.not_termins
    end
  end

  # Returns the start_date if before, the end_date if during and none if after.
  # /d.wessman
  def countdown
    i = view_status
    if i == 1
      return start
    elsif i == 2
      return self.end
    end
    nil
  end

  def candidate_count(post)
    if post.present?
      candidates.where(post_id: post.id).count
    else
      0
    end
  end

  def can_candidate?(post)
    if post.elected_by == 'Terminsmötet' && view_status == 2
      return true
    elsif post.elected_by != 'Terminsmötet' && view_status != 1
      return true
    end
    false
  end

  def to_param
    if url
      url
    else
      id
    end
  end
end
