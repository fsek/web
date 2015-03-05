# encoding: UTF-8
class Faq < ActiveRecord::Base
  validates :question, presence: true
  
end
