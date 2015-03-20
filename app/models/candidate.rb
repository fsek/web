# encoding: UTF-8
class Candidate < ActiveRecord::Base
  belongs_to :election
  belongs_to :profile
  belongs_to :post

  validates :profile_id, uniqueness: {scope: [:post_id, :election_id], message: "har redan en likadan kandidatur"}, on: :create
  validates :name, :lastname, :stil_id, :email, :phone, :post, :profile, :election, presence: true, on: :create
  validates :name, :lastname, :stil_id, :email, :phone, :profile, :election, presence: true, on: :update

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

  def owner?(user)
    user.present? && user.profile == self.profile
  end

  def editable?
    return (self.election.view_status == 2) || (self.post.elected_by == "Studierådet")
  end

  def p_url
    Rails.application.routes.url_helpers.election_candidate_url(self.id, host: PUBLIC_URL)
  end
end
