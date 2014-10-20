class Candidate < ActiveRecord::Base
  belongs_to :election
  belongs_to :profile
  belongs_to :post
  
  validates :stil_id,:email,:phone, :presence => {}
end
