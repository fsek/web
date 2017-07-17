class GroupView
  attr_accessor(:group, :message)

  def initialize(group)
    @group = group
    @message = Message.new(groups: [@group])
  end
end
