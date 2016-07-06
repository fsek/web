class Group < ActiveRecord::Base
  belongs_to :introduction, required: true
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users

  validates :name, presence: true
  validates :number, presence: true, numericality: { greater_than: 0 }

  acts_as_paranoid

  def to_s
    name + ' (' + introduction.year.to_s + ')'
  end
end
