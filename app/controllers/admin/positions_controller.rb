# encoding: UTF-8
class Admin::PositionsController < Admin::BaseController
  load_permissions_and_authorize_resource
  load_and_authorize_resource :council, parent: true, find_by: :url

  def add_user
    council = Council.find_by_url!(params[:council_id])
    @position_view = PositionView.new(council: council,
                                      position_user: PositionUser.new(position_user_params),
                                      users: User.by_firstname)
    @position_view = set_grids(@position_view)

    if PositionUserService.create(@position_view.position_user)
      redirect_to(admin_council_positions_path(@position_view.council),
                  notice: I18n.t('model.position.added',
                                 u: @position_view.position_user.user,
                                 p: @position_view.position_user.position))
    else
      render :index
    end
  end

  def remove_user
    position_user = PositionUser.find(params[:position_user_id])
    @status = I18n.t('model.position.user_removed',
                     u: position_user.user,
                     p: position_user.position)
    @id = params[:position_user_id]

    @state = position_user.destroy
  end

  def index
    council = Council.find_by_url!(params[:council_id])
    @position_view = PositionView.new(council: council,
                                      position_user: PositionUser.new,
                                      users: User.by_firstname)
    @position_view.position_grid = initialize_grid(council.positions,
                                                   order: :title,
                                                   name: 'positions')
    @position_view.position_user_grid = initialize_grid(council.position_users,
                                                        include: [:position, :user],
                                                        name: 'position_users')
  end

  def new
    @council = Council.find_by_url!(params[:council_id])
    @position = @council.positions.build
  end

  def edit
    @councils = Council.order(title: :asc)
  end

  def create
    @council = Council.find_by_url!(params[:council_id])
    @position = @council.positions.build(position_params)
    if @position.save
      redirect_to admin_council_positions_path(@council), notice: alert_create(Position)
    else
      render :new, status: 422
    end
  end

  def update
    @council = Council.find_by_url!(params[:council_id])
    @position = @council.positions.find(params[:id])

    if @position.update(position_params)
      redirect_to(edit_admin_council_position_path(@council, @position),
                  notice: alert_update(Position))
    else
      render :edit, status: 422
    end
  end

  def destroy
    council = Council.find_by_url!(params[:council_id])
    position = council.positions.find(params[:id])

    position.destroy!
    redirect_to admin_council_positions_path(council), notice: alert_destroy(Position)
  end

  private

  def set_grids(position_view)
    position_view.position_grid = initialize_grid(position_view.council.positions,
                                                  order: :title,
                                                  name: 'positions')
    position_view.position_user_grid = initialize_grid(position_view.council.position_users,
                                                       include: [:position, :user],
                                                       name: 'position_users')

    position_view
  end

  def position_params
    params.require(:position).permit(:title, :limit, :rec_limit,
                                     :description, :elected_by, :semester,
                                     :board, :car_rent, :council_id)
  end

  def position_user_params
    params.require(:position_user).permit(:user_id, :position_id)
  end
end
