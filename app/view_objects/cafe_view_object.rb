class CafeViewObject
  attr_accessor :users, :councils, :shift

  def initialize(users: [], councils: [], shift: nil)
    @users = users
    @councils = councils
    @shift = shift
  end
end
