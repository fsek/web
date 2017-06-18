class MessagesController < ApplicationController
  before_action :load_permissions
  load_and_authorize_resource :group, parent: true, except: :destroy
  load_and_authorize_resource :message

  def index
    @messages = @group.messages.by_latest.includes(:user, message_comments: :user)
  end

  def new
    @message.groups = [@group]
  end

  def create
    @message.groups = [@group]
    @message.user = current_user
    @message.introduction = @group.introduction
    if @message.save
      redirect_to(group_path(@group), notice: alert_create(Message))
    else
      render(:new, status: 422)
    end
  end

  def destroy
    message = Message.find(params[:id])
    message.destroy!

    redirect_back(fallback_location: root_path, notice: alert_destroy(Message))
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
