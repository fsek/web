module UsersHelper
  def display_phone?(user:, current_user:)
    user.display_phone? && user.phone.present? && user.groups.merge(current_user.groups).any?
  end
end
