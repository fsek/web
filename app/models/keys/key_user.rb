class KeyUser < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :key, required: true
end
