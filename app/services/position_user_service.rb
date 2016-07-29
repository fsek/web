module PositionUserService
  def self.create(position_user)
    position_user.validate

    if position_user.position.try(:limited?)
      position_user.errors.add(:position, I18n.t('position.limited'))
      return false
    end

    position_user.save
  end
end
