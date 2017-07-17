class Api::PushDevicesController < Api::BaseController
  load_permissions_and_authorize_resource

  def create
    @push_device = current_user.push_devices.find_or_create_by(push_device_params)

    if @push_device
      render json: {}, status: :ok
    else
      render json: { errors: 'Failed to create push device' }, status: 422
    end
  end

  def destroy
    @push_device = current_user.push_devices.find_by(token: params[:token])

    if @push_device && @push_device.destroy
      render json: {}, status: :ok
    else
      render json: { errors: 'Failed to destroy push device' }, status: 422
    end
  end

  private

  def push_device_params
    params.require(:push_device).permit(:token, :system)
  end
end
