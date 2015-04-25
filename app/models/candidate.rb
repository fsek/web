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
  validates :firstname, :lastname, :stil_id, :email,
    :phone, :post, :user, :election, presence: true

  after_create :send_email
  after_update :send_email

  def send_email
    ElectionMailer.candidate_email(self).deliver_now
  end

  # A custom class for the person candidating
  # For more information see Assignee model or
  # read comments above methods
  def person
    @person || Assignee.new(person_attributes)
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

  def person_attributes
    {
      firstname: firstname, lastname: lastname, email: email,
      phone: phone, user: user, user_id: user_id
    }
  end
end
