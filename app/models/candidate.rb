class Candidate < ApplicationRecord
  belongs_to :election, required: true, inverse_of: :candidates
  belongs_to :user, required: true
  belongs_to :post, required: true
  has_one :council, through: :post

  validates :post, uniqueness: { scope: [:user, :election],
                                 message: I18n.t('model.candidate.similar_candidate') }

  validate :user_attributes
  validate :check_edit, if: Proc.new { |o| o.election.present? && o.post.present? }

  def editable?
    if election.present? && post.present?
      election.searchable_posts.where(id: post.id).any?
    else
      false
    end
  end

  def editable_until
    if election.present? && post.present?
      election.post_closing(post)
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
      errors.add(:post, I18n.t('model.candidate.not_editable'))
    end
  end
end
