class Admin::IntroductionsController < Admin::BaseController
  load_permissions_and_authorize_resource(find_by: :slug)

  def index
    @grid = initialize_grid(Introduction, order: :start, locale: :sv)
  end

  def show
  end

  def new
    @introduction = Introduction.new
  end

  def edit
  end

  def create
    @introduction = Introduction.new(introduction_params)
    if @introduction.save
      redirect_to(edit_admin_introduction_path(@introduction), notice: alert_create(Introduction))
    else
      render :new, status: 422
    end
  end

  def update
    if @introduction.update(introduction_params)
      redirect_to(edit_admin_introduction_path(@introduction), notice: alert_update(Introduction))
    else
      render :edit, status: 422
    end
  end

  def destroy
    @introduction.destroy!

    redirect_to(admin_introductions_path, notice: alert_destroy(Introduction))
  end

  private

  def introduction_params
    params.require(:introduction).permit(:title_sv, :title_en, :description_sv, :description_en,
                                         :start, :stop, :slug, :current)
  end
end
