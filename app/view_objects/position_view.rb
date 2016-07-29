class PositionView
  attr_reader :council, :position_user, :users
  attr_accessor :position_grid, :position_user_grid

  def initialize(council:, position_user: nil, users: [])
    @council = council
    @position_user = position_user
    @users = users
  end
end
