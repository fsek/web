class GroupMessage < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :group, required: true
  belongs_to :message, required: true

  validates :group, uniqueness: { scope: :message }
end
