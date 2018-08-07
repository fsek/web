# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :load_permissions
  load_and_authorize_resource :group, parent: true
  load_and_authorize_resource :message

  def index
    @messages = @group.messages.for_index.page(params[:page])
    reset_counter unless params.has_key?(:page)

    render json: @messages,
           scope: @group.id,
           meta: pagination_meta(@messages)
  end

  def download_image
    if params[:size] == 'full'
      send_file @message.image.url, disposition: 'inline'
    elsif params[:size] == 'large'
      send_file @message.image.large.url, disposition: 'inline'
    else
      send_file @message.image.thumb.url, disposition: 'inline'
    end
  end

  private

  def reset_counter
    @group_user = @group.group_users.find_by(user: current_user)
    @group_user.update!(unread_count: 0)
  end
end
