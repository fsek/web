class Group < ActiveRecord::Base
  belongs_to :introduction, required: true
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users

  REGULAR = 'regular'.freeze
  MISSION = 'mission'.freeze

  validates :name, presence: true
  validates :number, presence: true, numericality: { greater_than: 0 }, if: :regular?
  validates :number, absence: true, if: :mission?
  validates :group_type, presence: true, inclusion: { in: [REGULAR, MISSION] }

  scope :regular, -> { where(group_type: REGULAR) }
  scope :missions, -> { where(group_type: MISSION) }

  acts_as_paranoid

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
