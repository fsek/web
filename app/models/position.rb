# encoding: UTF-8
class Position < ActiveRecord::Base
  AUTUMN = 'autumn'.freeze
  SPRING = 'spring'.freeze
  BOTH = 'both'.freeze
  OTHER = 'other'.freeze

  BOARD = 'board'.freeze
  EDUCATION = 'education'.freeze
  GENERAL = 'general'.freeze
  EXTRA = 'extra'.freeze

  # Associations
  belongs_to :council, required: true
  has_many :position_users
  has_many :users, through: :position_users

  has_many :nominations
  has_many :candidates

  has_many :permission_positions
  has_many :permissions, through: :permission_positions
  has_many :accesses
  has_many :doors, through: :accesses

  # Scopes
  scope :board, -> { where(elected_by: BOARD) }
  scope :education, -> { where(elected_by: EDUCATION) }
  scope :general, -> { where(elected_by: GENERAL) }
  scope :not_general, -> { where.not(elected_by: GENERAL) }

  scope :autumn, -> { where('semester = ? OR semester = ?', AUTUMN, BOTH) }
  scope :spring, -> { where('semester = ? OR semester = ?', SPRING, BOTH) }
  scope :both, -> { where(semester: BOTH) }

  # Validations
  validates(:title, :description, :limit,
            :rec_limit, :elected_by, :semester, presence: true)

  # Scopes
  scope :renters, -> { where(car_rent: true) }
  scope :by_title, -> { order(title: :asc) }

  def to_s
    title
  end

  def limited?
    limit > 0 && users.count >= limit
  end

  def set_permissions(params)
    self.permissions = []
    params[:permission_ids].each do |id|
      if id.present?
        permissions << Permission.find(id)
      end
    end
    save!
  end
end
