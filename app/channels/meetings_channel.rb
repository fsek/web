class MeetingsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "meetings_channel"
  end

  def unsubscribed
    #ConnectedList.remove(current_user.id, params['group_id'])
  end
end
