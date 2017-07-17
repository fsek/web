class Admin::MessagesController < Admin::BaseController
  load_permissions_and_authorize_resource
  before_action :set_introduction, only: [:index, :new, :create]
  include MessageHelper

  def index
    @messages = @introduction.messages.for_admin
  end

  def new
    @message = Message.new
    @message.groups = group_preset(params[:preset], @introduction) || []
  end

  def create
    @message.user = current_user
    @message.by_admin = true
    @message.introduction = @introduction

    if @message.save
      MessageService.broadcast_create(@message)
      redirect_to admin_introduction_messages_path, notice: alert_create(Message)
    else
      render :new, status: 422
    end
  end

  def edit
    @message = Message.find(params[:id])
  end

  def update
    @message = Message.find(params[:id])

    if @message.update(message_params)
      MessageService.broadcast_update(@message)
      redirect_to(admin_introduction_messages_path(@message.introduction), notice: alert_update(Message))
    else
      render :edit, status: 422
    end
  end

  def destroy
    message = Message.by_admin.find(params[:id])
    MessageService.destroy_message(message)

    redirect_back(fallback_location: root_path, notice: alert_destroy(Message))
  end

  private

  def message_params
    params.require(:message).permit(:content, group_ids: [])
  end

  def set_introduction
    @introduction = Introduction.find_by!(slug: params[:introduction_id])
  end
end
