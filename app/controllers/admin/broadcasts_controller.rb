# encoding:UTF-8
class Admin::BroadcastsController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index 
    @broadcasts = Broadcast.all
    @users = User.all
  end

  def update  
    @broadcast = Broadcast.find(params[:id])
    if @broadcast.update(broadcast_params)
      redirect_to admin_broadcasts_path, notice: alert_update(broadcast)
    else
      redirect_to edit_admin_broadcasts_path, notice: alert_danger(@broadcast.errors.full_messages)
    end
  end

  def new
    @key = Key.new
  end

  def create
    @broadcast = Broadcast.new(broadcast_params)
    if @broadcast.save
      redirect_to admin_broadcasts_path
    else
      render 'new'
    end
  end

  def broadcast_params
    params.require(:broadcast).permit(:title, :content, :image, :user_id)
  end
end
