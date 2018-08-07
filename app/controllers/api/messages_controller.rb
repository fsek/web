class Api::MessagesController < Api::BaseController
  before_action :load_permissions
  load_and_authorize_resource :group, parent: true, only: [:index, :create]
  load_and_authorize_resource :message

  def index
    @messages = @group.messages.for_index.page(params[:page])
    reset_counter unless params.has_key?(:page)

    render json: @messages,
           scope: @group.id,
           meta: pagination_meta(@messages),
           namespace: ''
  end

  def create
    MessageService.create_message(message_params, [@group], current_user)
    render json: {}, status: :ok
  end

  def edit
    render json: { content: @message.content }
  end

  def new_token
    data = MessageToken.add(current_user.id)
    render json: data
  end

  private

  def message_params
    params.require(:message).permit(:content, :image)
  end

  def reset_counter
    @group_user = @group.group_users.find_by(user: current_user)
    @group_user.update!(unread_count: 0)
  end
end
