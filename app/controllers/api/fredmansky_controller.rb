class Api::FredmanskyController < Api::BaseController
  load_permissions_and_authorize_resource

  def create
    if Fredmansky.create(user: current_user)
      render json: {}, status: :ok
    else
      render json: { errors: 'Failed to create Fredmansky' }, status: 422
    end
  end

  def destroy
    @fredmansky = Fredmansky.find_by(user: current_user)

    if @fredmansky && @fredmansky.destroy
      render json: {}, status: :ok
    else
      render json: { errors: 'Failed to destroy Fredmansky' }, status: 422
    end
  end
end
