class PostView
  attr_reader :council, :post_user, :users
  attr_accessor :post_grid, :post_user_grid

  def initialize(council:, post_user: nil, users: [])
    @council = council
    @post_user = post_user
    @users = users
  end
end
