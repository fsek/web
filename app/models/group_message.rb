class GroupMessage < ApplicationRecord
  acts_as_paranoid

  belongs_to :group, required: true
  belongs_to :message, required: true

  validates :group, uniqueness: { scope: :message }
  validate :same_introduction

  private

  def same_introduction
    unless group.introduction == message.introduction
      errors.add(:groups, I18n.t('model.message.group_introduction_error'))
    end
  end
end
