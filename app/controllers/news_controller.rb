# encoding:UTF-8
class NewsController < ApplicationController
  include TheRole::Controller
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_news, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_news, only: [:new, :edit]

  def index
    @news = News.all
  end

  def show
  end

  def new
    @news = News.new
  end

  def edit
  end

  def create
    @news = News.new(news_params)
    @news.user = current_user
    if @news.save
      flash[:notice] = 'Nyheten skapades.'
      redirect_to @news
    else
      render action: :new
    end
  end

  def update
    if @news.update(news_params)
      flash[:notice] = 'Nyheten uppdaterades'
      redirect_to @news
    else
      render action: :edit
    end
  end

  def destroy
    @news.destroy
    redirect_to :news_index, notice: 'Nyheten raderades'
  end

  private
  def authenticate_news
    flash[:error] = t('the_role.access_denied')
    redirect_to(:back) unless current_user.moderator?(:nyheter)

  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_news
    @news = News.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def news_params
    params.require(:news).permit(:title, :content, :image)
  end
end
