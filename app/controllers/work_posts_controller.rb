# encoding:UTF-8
class WorkPostsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate, only: [:new, :create, :edit, :destroy, :update]
  before_action :set_edit
  before_action :set_work_post, except: [:index, :new, :create]

  def index
    @work_posts = WorkPost.publish
    @work_post_grid = initialize_grid(WorkPost.publish)
    @not_published_grid = initialize_grid(WorkPost.unpublish)
    if WorkPost.unpublish.count > 0
      @edit_grid = true
    end
  end

  def show
  end

  def new
    @work_post = WorkPost.new
  end

  def edit
  end

  def create
    @work_post = WorkPost.new(work_post_params)
    @work_post.responsible = current_user.profile.id
    respond_to do |format|
      if @work_post.save
        format.html { redirect_to work_posts_path, notice: 'Jobbposten skapades, success!.' }
        format.json { render action: 'show', status: :created, location: @work_post }
      else
        format.html { render action: 'new' }
        format.json { render json: @work_post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @work_post.update(work_post_params)
        format.html { redirect_to work_posts_path, notice: 'Jobbposten uppdaterades, gött' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @work_post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @work_post.destroy
    respond_to do |format|
      format.html { redirect_to work_posts_path, notice: 'Jobbposten raderades.' }
      format.json { head :no_content }
    end
  end

  private

  def authenticate
    flash[:error] = t('the_role.access_denied')
    redirect_to(:back) unless current_user.moderator?(:jobbportal)

  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  def set_edit
    if (current_user) && (current_user.moderator?(:jobbportal))
      @edit = true
    else
      @edit = false
    end
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_work_post
    @work_post = WorkPost.find_by_id(params[:id])
    if (@work_post == nil)
      @work_post = WorkPost.new
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def work_post_params
    params.fetch(:work_post).permit(:title, :description, :company, :deadline, :kind, :for, :visible, :publish, :picture, :category, :link)
  end
end
