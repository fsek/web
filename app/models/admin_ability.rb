class AdminAbility
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Add abilities gained from posts
    user.posts.includes(:permissions).each do |post|
      post.permissions.each do |permission|
        can(permission.action.to_sym, permission.subject)
      end
    end
  end
end
