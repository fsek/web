module Constraints
  class Sidekiq
    def matches?(request)
      user = request.env['warden'].user
      return false if user.blank?
      AdminAbility.new(user).can?(:manage, Sidekiq)
    end
  end
end
