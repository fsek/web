class ElectionPosition < ActiveRecord::Base
  belongs_to :election, required: true
  belongs_to :position, required: true

  validates :position, uniqueness: { scope: :election }
end
