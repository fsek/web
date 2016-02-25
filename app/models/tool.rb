class Tool < ActiveRecord::Base

  validates :title, :description, presence: true

end
