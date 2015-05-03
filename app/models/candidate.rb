# encoding: UTF-8
class Candidate < ActiveRecord::Base
  # Associations
  belongs_to :election
  belongs_to :user
  belongs_to :post

  # Validations
  validates :user_id, uniqueness: {
    scope: [:post_id, :election_id], message: I18n.t('candidates.similar_candidate')
  }, on: :create
  validates :post, :user, :election, presence: true
  validate :user_attributes

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
    election.view_status == :during || post.elected_by == 'Studierådet'
  end

  def p_url
    Rails.application.routes.url_helpers.candidate_url(id, host: PUBLIC_URL)
  end

  def p_path
    Rails.application.routes.url_helpers.candidate_path(id)
  end

  protected

  def user_attributes
    if user.present? && user.firstname.present? &&
      user.lastname.present? && user.email.present? &&
      user.phone.present? && user.stil_id.present?
      return true
    end

    errors.add(:user,'Du måste fylla i dina användaruppgifter')
    false
  end
end
