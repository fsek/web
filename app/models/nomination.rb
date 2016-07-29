# encoding: UTF-8
class Nomination < ActiveRecord::Base
  belongs_to :election, required: true
  belongs_to :position, required: true

  validates :name, :email, presence: true
  validates :email, format: { with: /\A.+@.+\..+\z/i,
                              message: I18n.t('model.nomination.invalid_email') }
  validate :valid_position, if: Proc.new { |o| o.election.present? && o.position.present? }

  def candidate_url
    Rails.application.routes.url_helpers.new_candidate_url(position: position,
                                                           host: PUBLIC_URL)
  end

  private

  def valid_position
    unless election.searchable_positions.where(id: position.id).any?
      errors.add(:position, I18n.t('model.nomination.not_valid_position'))
    end
  end
end
