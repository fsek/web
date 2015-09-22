class ExLink < ActiveRecord::Base
  validates :label, presence: true
  validates :url, presence: true
end
