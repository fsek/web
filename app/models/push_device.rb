class PushDevice < ApplicationRecord
  enum system: { android: 0, ios: 1 }

  belongs_to :user, required: true
  validates :system, presence: true
  validates :token, presence: true, uniqueness: { scope: [:user_id] }

  def to_param
    token
  end
end
