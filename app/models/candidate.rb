# encoding: UTF-8
class Candidate < ActiveRecord::Base
  belongs_to :election, required: true, inverse_of: :candidates
  belongs_to :user, required: true
  belongs_to :position, required: true
  has_one :council, through: :position

  validates :position, uniqueness: { scope: [:user, :election],
                                 message: I18n.t('model.candidate.similar_candidate') }

  validate :user_attributes
  validate :check_edit, if: Proc.new { |o| o.election.present? && o.position.present? }

  def editable?
    if election.present? && position.present?
      election.searchable_positions.where(id: position.id).any?
    else
      false
    end
  end

  def p_url
    Rails.application.routes.url_helpers.candidate_url(id, host: PUBLIC_URL)
  end

  def editable_until
    if election.present? && position.present?
      election.position_closing(position)
    end
  end

  private

  def user_attributes
    unless user.present? && user.has_attributes?
      errors.add(:user, I18n.t('model.candidate.add_user_information'))
    end
  end

  def check_edit
    unless editable?
      errors.add(:position, I18n.t('model.candidate.not_editable'))
    end
  end
end
