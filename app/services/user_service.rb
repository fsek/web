module UserService
  def self.make_member(user)
    user.update!(member_at: Time.zone.now)
  end

  def self.unmember(user)
    user.update!(member_at: nil)
  end
end
