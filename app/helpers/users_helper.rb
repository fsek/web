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

  def food_preferences_str(user)
    ary = user.food_preferences.delete_if(&:blank?).map { |f| I18n.t("model.user.food_prefs.#{f}") }
    ary << user.food_custom if user.food_custom.present?
    ary.join(', ')
  end

  def food_prefs_collection(user)
    User::FOOD_PREFS.map { |f| [I18n.t("model.user.food_prefs.#{f}"), f] }
  end
end
