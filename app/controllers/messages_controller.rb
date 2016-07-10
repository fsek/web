class MessagesController < ApplicationController
  before_action :load_permissions
  load_and_authorize_resource :group, parent: true
  load_and_authorize_resource :message

  def index
    @messages = @group.messages.by_latest.includes(user: :first_post, message_comments: :user)
  end

  def new
  end

  def create
    @message.groups = [@group]
    @message.user = current_user
    if @message.save
      redirect_to(group_path(@group), notice: alert_create(Message))
    else
      render(:new, status: 422)
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
