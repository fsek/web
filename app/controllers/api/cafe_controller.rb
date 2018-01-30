class Api::CafeController < Api::BaseController
  load_and_authorize_resource :cafe_shift, :cafe_worker

  def index
    @shifts = CafeQueries.between_by_start(params[:start], params[:end])
    @shifts = CafeService.group_cafe_shifts(params[:start], params[:end], @shifts)

    render json: @shifts
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
    @cafe_user = current_user.cafe_shifts.find(params[:id]).cafe_worker

    if @cafe_user&.destroy
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
