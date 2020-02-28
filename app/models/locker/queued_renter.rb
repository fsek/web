class QueuedRenter < ApplicationRecord
  belongs_to :user, required: true
end
