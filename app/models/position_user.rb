# encoding: UTF-8
class PositionUser < ActiveRecord::Base
  belongs_to :position, required: true
  belongs_to :user, required: true
  has_one :council, through: :position

  validates :user_id, uniqueness: { scope: :position_id,
                                    message: I18n.t('model.position_user.already_have_position') }

  def to_s
    %(#{user} == #{position})
  end
end
