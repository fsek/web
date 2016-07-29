class Access < ActiveRecord::Base
  belongs_to :door, required: true
  belongs_to :position, required: true

  validates(:door, uniqueness: { scope: :position })
end
