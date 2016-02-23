# encoding: UTF-8
class Post < ActiveRecord::Base
  AUTUMN = 'autumn'.freeze
  SPRING = 'spring'.freeze
  BOTH = 'both'.freeze
  OTHER = 'other'.freeze

  BOARD = 'board'.freeze
  EDUCATION = 'education'.freeze
  GENERAL = 'general'.freeze
  EXTRA = 'extra'.freeze

  # Associations
  belongs_to :council
  has_many :post_users
  has_many :users, through: :post_users

  has_many :nominations
  has_many :candidates

  has_many :permission_posts
  has_many :permissions, through: :permission_posts

  # Scopes
  scope :board, -> { where(elected_by: BOARD) }
  scope :education, -> { where(elected_by: EDUCATION) }
  scope :general, -> { where(elected_by: GENERAL) }

  scope :autumn, -> { where('semester = ? OR semester = ?', AUTUMN, BOTH) }
  scope :spring, -> { where('semester = ? OR semester = ?', SPRING, BOTH) }
  scope :both, -> { where(semester: BOTH) }

  # Validations
  validates :council_id, :title, :description, :limit, :rec_limit, presence: true

  # Scopes
  scope :renters, -> { where(car_rent: true) }
  scope :title, -> { order(title: :asc) }

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
