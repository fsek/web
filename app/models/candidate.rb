# encoding: UTF-8
class Candidate < ActiveRecord::Base
  # Associations
  belongs_to :election
  belongs_to :user
  belongs_to :post
  has_one :council, through: :post

  # Validations
  validates :user_id, uniqueness: {
    scope: [:post_id, :election_id], message: I18n.t('candidates.similar_candidate')
  }, on: :create
  validates :post, :user, :election, presence: true
  validate :user_attributes

  validate :check_edit
  after_create :send_email
  after_update :send_email

  def send_email
    ElectionMailer.candidate_email(self).deliver_now
  end

  def prepare(user)
    if user.present?
      self.attributes = person.load_user(user)
      self.stil_id = user.stil_id
    end
  end

  def owner?(user)
    self.user == user
  end

  def editable?
    v = election.try(:view_status)
    if v == :during
      return true
    elsif ['Studierådet', 'Styrelsen'].include?(post.elected_by) && v == :after
      return true
    else
      return false
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
