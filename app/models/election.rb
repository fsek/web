# encoding: UTF-8
class Election < ActiveRecord::Base
  has_many :nominations, dependent: :destroy
  has_many :candidates, dependent: :destroy
  has_and_belongs_to_many :posts

  validates :url, presence: true, uniqueness: true
  validates :start, :end, presence: true

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
  def view_status
    if start > Time.zone.now
      return :before
    elsif start <= Time.zone.now && self.end > Time.zone.now
      return :during
    elsif closing.nil? ||  closing > Time.zone.now
      return :after
    else
      return :closed
    end
  end

  # Returns a status text depending on the view_status
  def status_text
    case view_status
    when :before
      text_before
    when :during
      text_during
    when :after, :closed
      text_after
    end
  end

  # Returns a status text for the nominations page
  def nomination_status
    if view_status == :after
      I18n.t('nominations.status_after')
    end
  end

  # Returns the current posts
  def current_posts
    if view_status == :after
      posts.not_termins
    else
      posts
    end
  end

  # Returns the start_date if before, the end_date if during and none if after.
  def countdown
    case view_status
    when :before
      start
    when :during
      self.end
    when :after
      closing || nil
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
    if post.elected_by == 'Terminsmötet' && view_status == :during
      return true
    elsif post.elected_by != 'Terminsmötet' && view_status != :before
      return true
    end

    false
  end

  def to_param
    (url.present?) ? url : id
  end
end
