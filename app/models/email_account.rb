class EmailAccount < ActiveRecord::Base
  has_many :emails
  belongs_to :profile
end
