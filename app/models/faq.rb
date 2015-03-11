# encoding: UTF-8
class Faq < ActiveRecord::Base
  validates :question, presence: true

  scope :answered, -> {where.not(answer: nil)}
  scope :category,->(category) {where(category: category)}
end
