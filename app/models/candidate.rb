# encoding: UTF-8
class Candidate < ActiveRecord::Base
  belongs_to :election
  belongs_to :user
  belongs_to :post

  validates :user_id, uniqueness: {
                        scope: [:post_id, :election_id], message: 'har redan en likadan kandidatur'
                    }, on: :create
  validates :name, :lastname, :stil_id, :email,
            :phone, :post, :user, :election, presence: true

  after_create :send_email
  after_update :send_email

  def send_email
    ElectionMailer.candidate_email(self).deliver_now
  end

  def prepare(user)
    if user.present?
      self.user = user
      self.name = user.name
      self.lastname = user.lastname
      self.email = user.email
      self.phone = user.phone
      self.stil_id = user.stil_id
    end
  end

  def owner?(user)
    user.present? && user == self.user
  end

  def editable?
    election.view_status == 2 || post.elected_by == 'Studierådet'
  end

  def p_url
    Rails.application.routes.url_helpers.election_candidate_url(id, host: PUBLIC_URL)
  end
end
