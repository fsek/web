class EmailAccount < ActiveRecord::Base

  has_many :emails
  belongs_to :profile
  validates :profile_id,:email,:title,:presence => {}
end
