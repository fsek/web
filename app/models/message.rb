class Message < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :user, required: true

  has_many :message_comments, dependent: :destroy
  has_many :group_messages, dependent: :destroy
  has_many :groups, through: :group_messages

  validates :content, presence: true
  validates :groups, length: { minimum: 1, message: I18n.t('model.message.need_groups') }
  validate :in_group, unless: :is_admin
  attr_accessor :is_admin

  scope :by_latest, -> { order(created_at: :desc) }
  scope :by_user, ->(user) { where(user: user) }
  scope :for_user, ->(user) { joins(groups: :users).merge(User.where(id: user.id)) }

  def with_group(user)
    if user.present?
      groups.merge(user.groups).any?
    end
  end

  private

  def with_all_groups?
    (group_ids - user.group_ids).empty?
  end

  def in_group
    unless user.nil? || with_all_groups?
      errors.add(:groups, I18n.t('model.message.not_part_of_selected_groups'))
    end
  end
end
