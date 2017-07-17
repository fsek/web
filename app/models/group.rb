class Group < ApplicationRecord
  acts_as_paranoid

  belongs_to :introduction

  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  has_many :group_messages, dependent: :destroy
  has_many :messages, through: :group_messages
  has_many :adventure_groups, dependent: :destroy

  REGULAR = 'regular'.freeze
  MISSION = 'mission'.freeze
  OTHER = 'other'.freeze

  validates :name, presence: true
  validates :number, presence: true, numericality: { greater_than: 0 }, if: :regular?
  validates :number, absence: true, unless: :regular?
  validates :group_type, presence: true, inclusion: { in: [REGULAR, MISSION, OTHER] }

  scope :regular, -> { where(group_type: REGULAR) }
  scope :missions, -> { where(group_type: MISSION) }
  scope :others, -> { where(group_type: OTHER) }
  scope :for_show, -> { includes(:introduction) }

  def regular?
    group_type == REGULAR
  end

  def mission?
    group_type == MISSION
  end

  def other?
    group_type == OTHER
  end

  def to_s
    if introduction.present?
      name + ' (' + introduction.year.to_s + ')'
    else
      name
    end
  end
end
