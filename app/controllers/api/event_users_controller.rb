class Api::EventUsersController < Api::BaseController
  before_action :load_permissions
  load_and_authorize_resource :event, parent: true
  load_and_authorize_resource :event_user, through: :event

  def create
    @event_user = @event.event_users.build(event_user_params)
    @event_user.user = current_user

    if @event_user.save
      render json: @event_user
    else
      render json: { errors: @event_user.errors.full_messages }, status: 422
    end
  end

  def destroy
    @event_user = current_user.event_users.find(params[:id])

    if @event_user.event_signup.open?
      if @event_user.destroy
        render json: {}, status: :ok
      else
        render json: { errors: @event_user.errors.full_messages }, status: 500
      end
    else
      render json: { errors: ['Signup is not open'], status: 422 }
    end
  end

  private

  def event_user_params
    params.require(:event_user).permit(:answer, :user_type, :group_id, :group_custom)
  end
end
