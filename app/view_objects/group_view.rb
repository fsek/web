class GroupView
  attr_accessor(:group, :adventures, :messages)
  def initialize(group, message_limit: 5)
    @group = group
    if group.present? && group.group_type == Group::REGULAR
      @adventures = @group.adventure_groups.
                    includes(:introduction, adventure: :translations).
                    by_adventure_desc.
                    published_results
    else
      @adventures = []
    end

    @messages = @group.messages.
                includes(:user, message_comments: :user).
                by_latest.
                limit(message_limit)
  end
end
