# encoding: UTF-8
class Nomination < ActiveRecord::Base
  belongs_to :election
  belongs_to :post

  validates :name, :email, :post_id, presence: true
  validates :email, format: { with: /\A.+@.+\..+\z/i,
                              message: I18n.t('model.nomination.invalid_email') }

  after_create :send_email

  def send_email
    ElectionMailer.nominate_email(self).deliver_now
  end

  def candidate_url
    Rails.application.routes.url_helpers.new_candidate_url(post: post, host: PUBLIC_URL)
  end
end
