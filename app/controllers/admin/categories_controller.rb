class Admin::CategoriesController < Admin::BaseController
  load_permissions_and_authorize_resource find_by: :slug

  def index
    @categories = @categories.by_title
  end

  def new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to admin_categories_path, notice: alert_create(Category)
    else
      render :new, status: 422
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to edit_admin_category_path(@category), notice: alert_update(Category)
    else
      render :edit, status: 422
    end
  end

  def destroy
    @category.destroy!

    redirect_to admin_categories_path, notice: alert_destroy(Category)
  end

  private

  def category_params
    params.require(:category).permit(:title_en, :title_sv, :slug, :use_case)
  end
end
