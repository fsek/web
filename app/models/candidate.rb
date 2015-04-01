# encoding: UTF-8
class Candidate < ActiveRecord::Base
  # Associations
  belongs_to :election
  belongs_to :profile
  belongs_to :post

  # Validations
  validates :profile_id, uniqueness: {
    scope: [:post_id, :election_id], message: I18n.t('candidates.similar_candidate')
  }, on: :create
  validates :name, :lastname, :stil_id, :email,
            :phone, :post, :profile, :election, presence: true

  after_create :send_email
  after_update :send_email

  def send_email
    ElectionMailer.candidate_email(self).deliver_now
  end

  def prepare(user)
    if (user.present?) && (user.profile.present?)
      self.profile = user.profile
      self.name = user.profile.name
      self.lastname = user.profile.lastname
      self.email = user.profile.email
      self.phone = user.profile.phone
      self.stil_id = user.profile.stil_id
    end
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

  def owner?(user)
    user.present? && user.profile == profile
  end
end
