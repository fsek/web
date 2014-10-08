class Faq < ActiveRecord::Base
  validates :question, presence: true
  
end
