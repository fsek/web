class Group < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :introduction, required: true

  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  has_many :group_messages, dependent: :destroy
  has_many :messages, through: :group_messages
  has_many :adventure_groups, dependent: :destroy

  REGULAR = 'regular'.freeze
  MISSION = 'mission'.freeze

  validates :name, presence: true
  validates :number, presence: true, numericality: { greater_than: 0 }, if: :regular?
  validates :number, absence: true, if: :mission?
  validates :group_type, presence: true, inclusion: { in: [REGULAR, MISSION] }

  scope :regular, -> { where(group_type: REGULAR) }
  scope :missions, -> { where(group_type: MISSION) }

  def regular?
    group_type == REGULAR
  end

  def mission?
    group_type == MISSION
  end

  def to_s
    name + ' (' + introduction.year.to_s + ')'
  end
end
