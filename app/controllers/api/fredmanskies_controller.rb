class Api::FredmanskiesController < Api::BaseController
  load_permissions_and_authorize_resource

  def create
    if Fredmansky.create(user: current_user)
      render json: {
        enabled: true
      }, status: :ok
    else
      render json: { errors: 'You can not join Fredmans' }, status: 422
    end
  end

  def destroy
    @fredmansky = Fredmansky.find_by(user: current_user)

    if @fredmansky&.destroy
      render json: {
        enabled: false
      }, status: :ok
    else
      render json: { errors: 'You can not leave Fredmans' }, status: 422
    end
  end

  def toggle
    @fredmansky = Fredmansky.find_by(user: current_user)
    if @fredmansky
      destroy
    else
      create
    end
  end
end
