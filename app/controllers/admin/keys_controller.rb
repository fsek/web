class Admin::KeysController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @keys = initialize_grid(Key.all, order: 'name', order_direction: 'asc')
    @key_users = initialize_grid(KeyUser.all, order_direction: 'asc')
  end

  def new
    @key = Key.new
  end

  def setup
    @key_user = KeyUser.new
  end

  def create
    @key = Key.new(key_params)
    if @key.save
      redirect_to admin_keys_path
    else
      render 'new'
    end
  end

  def destroy_key_user
    key_user = KeyUser.find(params[:key_id])
    key_user.destroy!
    redirect_to admin_keys_path, notice: alert_destroy(KeyUser)
  end

  def destroy
    @key = Key.find(params[:id])
    if @key.destroy
      redirect_to admin_keys_path, notice: alert_destroy(Key)
    else
      redirect_to admin_keys_path, notice: alert_danger(@key.errors.full_messages)
    end
  end

  def setup_create
    @key_user = KeyUser.new(key_user_params)
    if @key_user.save
      redirect_to admin_keys_path, notice: alert_create(KeyUser)
    else
      redirect_to setup_admin_keys_path, notice: alert_danger(@key_user.errors.full_messages)
    end
  end

  def key_user_params
    params.require(:key_user).permit(:user_id, :key_id)
  end

  def key_params
    params.require(:key).permit(:name, :description, :total, :users)
  end

  def update
    @key = Key.find(params[:id])
    if @key.update(key_params)
      redirect_to admin_keys_path, notice: alert_update(Key)
    else
      redirect_to edit_admin_key_path, notice: alert_danger(@key.errors.full_messages)
    end
  end
end
