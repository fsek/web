# encoding: UTF-8
class Candidate < ActiveRecord::Base
  # Associations
  belongs_to :election
  belongs_to :user
  belongs_to :post
  has_one :council, through: :post

  # Validations
  validates :post_id, uniqueness: { scope: [:user_id, :election_id],
                                    message: I18n.t('candidate.similar_candidate') }
  validates :post, :user, :election, presence: true
  validate :user_attributes, :check_edit

  def owner?(user)
    self.user == user
  end

  def editable?
    if election.present?
      case election.state
      when :during
        return true
      when :after
        return !(post.elected_by == Post::GENERAL)
      else
        false
      end
    end
  end

  def check_edit
    if !editable?
      errors.add(:election, I18n.t('candidate.time_error'))
      return false
    end

    true
  end

  def p_url
    Rails.application.routes.url_helpers.candidate_url(id, host: PUBLIC_URL)
  end

  def p_path
    Rails.application.routes.url_helpers.candidate_path(id)
  end

  protected

  def user_attributes
    if user.present? && user.has_attributes?
      return true
    end

    errors.add(:user, I18n.t('user.add_information'))
    false
  end
end
