class ExLink < ActiveRecord::Base
  validates :label, :url, presence: true
end
