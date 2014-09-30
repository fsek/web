# encoding:UTF-8
class NewsController < ApplicationController
  include TheRole::Controller  
  before_filter :authenticate_user!, only: [:new,:edit,:create,:update,:destroy]
  before_action :set_news, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_news, only: [:new,:edit]
  
  def index  
    @news = News.all  
  end
  # GET /news/1
  # GET /news/1.json
  def show    
  end

  # GET /news/new
  def new
    @news = News.new
  end

  # GET /news/1/edit
  def edit
  end

  # POST /news
  # POST /news.json
  def create
    @news = News.new(news_params)
    @news.profile = current_user.profile        
    respond_to do |format|
      if @news.save
        format.html { redirect_to @news, notice: 'Nyheten skapades!' }
        format.json { render action: 'show', status: :created, location: @news }
      else
        format.html { render action: 'new' }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /news/1
  # PATCH/PUT /news/1.json
  def update
    respond_to do |format|
      if @news.update(news_params)
        format.html { redirect_to @news, notice: 'Nyheten uppdaterades!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /news/1
  # DELETE /news/1.json
  def destroy
    @news.destroy
    respond_to do |format|
      format.html { redirect_to :news_index }
      format.json { head :no_content }
    end
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
      params.require(:news).permit(:title, :content,:image)
    end
end
