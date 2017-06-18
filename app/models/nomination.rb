class Nomination < ApplicationRecord
  belongs_to :election, required: true
  belongs_to :post, required: true

  validates :name, :email, presence: true
  validates :email, format: { with: /\A.+@.+\..+\z/i,
                              message: I18n.t('model.nomination.invalid_email') }
  validate :valid_post, if: Proc.new { |o| o.election.present? && o.post.present? }

  def candidate_url
    Rails.application.routes.url_helpers.new_candidate_url(post: post,
                                                           host: PUBLIC_URL)
  end

  private

  def valid_post
    unless election.searchable_posts.where(id: post.id).any?
      errors.add(:post, I18n.t('model.nomination.not_valid_post'))
    end
  end
end
