class Candidate < ActiveRecord::Base
  belongs_to :election
  belongs_to :profile
  belongs_to :post
end
