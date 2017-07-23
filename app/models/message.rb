class Message < ApplicationRecord
  acts_as_paranoid

  belongs_to :introduction, optional: true
  belongs_to :user, required: true

  has_many :group_messages, dependent: :destroy
  has_many :groups, through: :group_messages

  paginates_per(15)

  validates :content, presence: true
  validates :groups, length: { minimum: 1, message: I18n.t('model.message.need_groups') }
  validate :in_group, unless: :by_admin

  scope :by_admin, -> { where(by_admin: true) }
  scope :by_latest, -> { order(sent_at: :desc) }
  scope :by_user, ->(user) { where(user: user) }
  scope :for_user, ->(user) { joins(groups: :users).merge(User.where(id: user.id)) }
  scope :for_admin, -> { includes(:user).by_admin.by_latest }
  scope :for_index, -> { includes(:user).by_latest }

  before_create(:set_sent_at)

  def data(group)
    MessageData.new(self, group)
  end

  def with_group(user)
    if user.present?
      groups.merge(user.groups).any?
    end
  end

  def group_names
    groups.pluck(:name).join(', ');
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

  def set_sent_at
    # The version of MySQL that we use can not store timestamps with a higher precision than seconds.
    # To avoid messages beeing displayed in the wrong order, we use the column `sent_at` to store
    # the time the message was sent in milliseconds from 1970.
    self.sent_at = (Time.now.to_f * 1000).to_i
  end
end
