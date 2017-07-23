class Api::MessagesController < Api::BaseController
  before_action :load_permissions
  load_and_authorize_resource :group, parent: true, only: :index
  load_and_authorize_resource :message

  def index
    @messages = @group.messages.for_index.page(params[:page])
    render json: @messages, meta: pagination_meta(@messages), namespace: ''
  end

  def edit
    render json: { content: @message.content }
  end

  def new_token
    data = MessageToken.add(current_user.id)
    render json: data
  end
end
