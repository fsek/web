class MessagesController < ApplicationController
  before_action :load_permissions
  load_and_authorize_resource :group, parent: true
  load_and_authorize_resource :message

  def index
    @messages = @group.messages.for_index.page(params[:page])
    render json: @messages, meta: pagination_meta(@messages)
  end
end
