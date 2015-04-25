# encoding: UTF-8
class PostUser < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  validates :user_id, :post_id, presence: true
end
