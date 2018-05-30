class Api::UsersController < Api::BaseController
  load_permissions_and_authorize_resource

  def update
    @user = current_user

    if @user.update(user_params)
      render json: {}, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:firstname, :lastname, :program, :start_year,
                                 :avatar, :student_id, :phone, :display_phone,
                                 :remove_avatar, :food_custom, :notify_messages,
                                 :notify_event_users, :notify_event_closing, food_preferences: [])
  end
end
