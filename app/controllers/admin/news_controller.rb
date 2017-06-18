class Admin::NewsController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @news_grid = initialize_grid(News,
                                 include: :user,
                                 order: 'news.created_at',
                                 locale: 'sv',
                                 order_direction: :desc)
  end

  def new
    @news = News.new
  end

  def edit
    @news = News.find(params[:id])
  end

  def create
    @news = News.new(news_params)
    @news.user = current_user
    if @news.save
      redirect_to edit_admin_news_path(@news), notice: alert_create(News)
    else
      render :new, status: 422
    end
  end

  def update
    @news = News.find(params[:id])
    if @news.update(news_params.merge!(updated_at: Time.zone.now))
      redirect_to edit_admin_news_path(@news), notice: alert_update(News)
    else
      render :edit, status: 422
    end
  end

  def destroy
    news = News.find(params[:id])
    news.destroy!

    redirect_to admin_news_index_path, notice: alert_destroy(News)
  end

  private

  def news_params
    params.require(:news).permit(:title_sv, :title_en, :content_sv, :content_en,
                                 :image, :pinned_from, :pinned_to,
                                 :remove_image, category_ids: [])
  end
end
