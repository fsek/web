class MessagesController < ApplicationController
  before_action :load_permissions
  load_and_authorize_resource :group, parent: true
  load_and_authorize_resource :message

  def index
    @messages = @group.messages.for_index.page(params[:page])
    reset_counter unless params.has_key?(:page)

    render json: @messages, meta: pagination_meta(@messages)
  end

  private

  def reset_counter
    @group_user = @group.group_users.find_by(user: current_user)
    @group_user.update!(unread_count: 0)
  end
end
