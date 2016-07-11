class Admin::MessageCommentsController < Admin::BaseController
  before_action :load_permissions
  load_and_authorize_resource :message, parent: true

  def create
    @message_comment = @message.message_comments.build(message_comment_params)
    @message_comment.user = current_user
    @message_comment.by_admin = true

    if @message_comment.save
      redirect_to(:back, notice: alert_create(MessageComment))
    else
      redirect_to(:back, alert: @message_comment.errors.to_h.to_s)
    end
  end

  def destroy
    comment = @message.message_comments.find(params[:id])
    comment.destroy!
    redirect_to(:back, notice: alert_destroy(MessageComment))
  end

  private

  def message_comment_params
    params.require(:message_comment).permit(:content)
  end
end
