module UsersHelper
  def display_phone?(user:, current_user:)
    user.display_phone? && user.phone.present? && user.groups.merge(current_user.groups).any?
  end

  def user_program_collection
    [[I18n.t('model.user.program.physics'), User::PHYSICS],
     [I18n.t('model.user.program.math'), User::MATH],
     [I18n.t('model.user.program.nano'), User::NANO],
     [I18n.t('model.user.program.other'), User::OTHER]]
  end
end
