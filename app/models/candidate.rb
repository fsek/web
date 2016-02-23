# encoding: UTF-8
class Candidate < ActiveRecord::Base
  belongs_to :election
  belongs_to :user
  belongs_to :post
  has_one :council, through: :post
  validates :post, :user, :election, presence: true

  validates :post_id, uniqueness: { scope: [:user_id, :election_id],
                                    message: I18n.t('candidate.similar_candidate')
  }

  validate :user_attributes
  validate :check_edit, :valid_post, if: Proc.new { |o| o.election.present? && o.post.present? }

  def owner?(user)
    self.user == user
  end

  def editable?
    if election.present?
      case election.state
      when :during
        true
      when :after
        !(post.elected_by == Post::GENERAL)
      else
        false
      end
    end
  end

  def p_url
    Rails.application.routes.url_helpers.candidate_url(id, host: PUBLIC_URL)
  end

  def p_path
    Rails.application.routes.url_helpers.candidate_path(id)
  end

  private

  def user_attributes
    if user.present? && user.has_attributes?
      return true
    end

    errors.add(:user, I18n.t('user.add_information'))
    false
  end

  def check_edit
    if !editable?
      errors.add(:election, I18n.t('candidate.time_error'))
      return false
    end

    true
  end

  def valid_post
    if election.semester != post.semester &&
        election.posts.where(id: post.id).count == 0
      errors.add(:post, I18n.t('candidate.post_invalid'))
      return false
    end

    true
  end
end
