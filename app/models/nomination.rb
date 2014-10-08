class Nomination < ActiveRecord::Base
  belongs_to :election
  belongs_to :post
  
  validates_presence_of :name,:email,:post_id
end
