class MessageData
  attr_reader :message, :group, :body

  def initialize(message, group)
    @message = message
    @group = group
    @body = "[#{message.user}]: #{MarkdownHelper.markdown_plain(@message.content)}"
  end

  def android_data
    { title: group.name, body: body, notId: -group.id, style: :inbox }
  end

  def ios_notification
    { title: group.name, body: body }
  end

  def ios_data
    # Use negative notification id to distinguish from `Notifications`
    { notification_id: -message.id }
  end
end
