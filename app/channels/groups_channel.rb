class GroupsChannel < ApplicationCable::Channel
  def subscribed
    group = Group.find(params['group_id'])

    if ability.can?(:show, group)
      stream_from "groups_#{params['group_id']}_channel"
      ConnectedList.add(current_user.id, group.id)
    end
  end

  def unsubscribed
    ConnectedList.remove(current_user.id, params['group_id'])
  end

  def send_message(data)
    group = Group.find(data['group_id'])
    return unless ability.can?(:show, group)

    params = { content: data['content'] }
    MessageService.create_message(params, [group], current_user)
  end

  def destroy_message(data)
    message = Message.find(data['message_id'])
    return unless ability.can?(:destroy, message)

    MessageService.destroy_message(message)
  end

  def update_message(data)
    message = Message.find(data['message_id'])
    return unless ability.can?(:update, message)

    message.update!(content: data['content'])
    MessageService.broadcast_update(message)
  end
end
