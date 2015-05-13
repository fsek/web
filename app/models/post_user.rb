# encoding: UTF-8
class PostUser < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  validates :user_id, :post_id, presence: true
  validates :user_id, uniqueness: { scope: :post_id }
end
