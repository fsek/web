class MessageComment < ApplicationRecord
  acts_as_paranoid

  belongs_to :message, required: true, counter_cache: true
  belongs_to :user, required: true
  validates :content, presence: true

  scope :by_user, ->(user) { joins(message: :group).where(user: user) }

  def with_group(user)
    if user.present?
      message.with_group(user)
    end
  end
end
