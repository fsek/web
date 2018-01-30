class Api::CafeController < Api::BaseController
  before_action :load_permissions
  load_and_authorize_resource :cafe_worker, parent: false

  def index
    @shifts = CafeQueries.between(params[:start], params[:end])
    render json: @shifts, each_serializer: Api::CafeSerializer::Index
  end

  def create
    cafe_shift = CafeShift.find(params[:cafe_shift_id])
    @cafe_worker = cafe_shift.build_cafe_worker(cafe_worker_params)

    if @cafe_worker.save
      render json: {}, status: :ok
    else
      render json: { errors: @cafe_worker.errors.full_messages }, status: 422
    end
  end

  def destroy
    @cafe_user = current_user.cafe_workers.find(params[:id])

    if @cafe_user && @cafe_user.destroy
      render json: {}, status: :ok
    else
      render json: { errors: 'Failed to destroy' }, status: 422
    end
  end

  private

  def cafe_worker_params
    params.require(:cafe_worker).permit(:user_id, :competition, :group, council_ids: [])
  end
end
