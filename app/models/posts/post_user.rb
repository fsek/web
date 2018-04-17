class PostUser < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_one :council, through: :post

  validates :user_id, :post_id, presence: true
  validates :user_id, uniqueness: { scope: :post_id,
                                    message: I18n.t('model.post_user.already_have_post') }
  scope :from_post, ->(id) { where(post_id: id) }

  def to_s
    %(#{user} == #{post})
  end
end
