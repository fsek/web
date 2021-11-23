class Broadcast < ApplicationRecord
    belongs_to :user, required: true
end