# encoding: UTF-8
class Nomination < ActiveRecord::Base
  belongs_to :election
  belongs_to :post

  validates :name, :email, :post_id, presence: true

  after_create :send_email

  def send_email
    ElectionMailer.nominate_email(self).deliver_now
  end

  def candidate_url
    Rails.application.routes.url_helpers.new_candidate_url(host: PUBLIC_URL)
  end
end
