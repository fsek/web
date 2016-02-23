# encoding: UTF-8
class Nomination < ActiveRecord::Base
  belongs_to :election
  belongs_to :post

  validates :name, :email, :post_id, presence: true
  validate :valid_post, if: Proc.new { |o| o.election.present? && o.post.present? }

  after_create :send_email

  def send_email
    ElectionMailer.nominate_email(self).deliver_now
  end

  def candidate_url
    Rails.application.routes.url_helpers.new_candidate_url(host: PUBLIC_URL)
  end

  private

  def valid_post
    if election.semester != post.semester &&
        election.posts.where(id: post.id).count == 0
      errors.add(:post, I18n.t('candidate.post_invalid'))
      return false
    end

    true
  end
end
