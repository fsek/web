class PostsController < ApplicationController
  include TheRole::Controller
  before_filter :authenticate_user!, only: [:new,:edit,:create,:update,:destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :remove_profile,:add_profile_username]
  before_filter :authenticate_editor_poster! 

  def remove_profile
    @profile = Profile.find(params[:profile_id])
    @post.profiles.delete(@profile)
    respond_to do |format|
    format.html { redirect_to '/poster', notice: @profile.name + ' har inte längre posten '+@post.title + '.'}
    end 
  end
  def add_profile_username
    @profile = User.find_by(username: params[:username]).profile
    if @profile.posts.include?(@post)
       respond_to do |format|
       format.html { redirect_to '/poster', flash: {alert: @profile.name + '(' + User.find(@profile).username + ') har redan posten '+@post.title + '.'}}
       end
    elsif @post.limit != nil && @post.profiles.size >= 1
      respond_to do |format|
       format.html { redirect_to '/poster', flash: {alert: @post.title + ' har sitt maxantal.'}}
       end   
    else 
      @post.profiles << @profile
      respond_to do |format|
      format.html { redirect_to '/poster', notice: @profile.name + '(' + User.find(@profile).username + ') tilldelades posten '+@post.title + '.'}
      end  
    end 
  end
  def index  
    @posts = Post.all  
  end
  # GET /news/1
  # GET /news/1.json
  
  def show    
  end

  # GET /news/new
  def new
    @post = Post.new
  end

  # GET /news/1/edit
  def edit
  end

  # POST /news
  # POST /news.json
  def create
    @post = Post.new(post_params)        
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Posten skapades!' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @posts.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /news/1
  # PATCH/PUT /news/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Posten uppdaterades!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /news/1
  # DELETE /news/1.json
  def destroy
    @post.profiles.clear
    @post.destroy
    respond_to do |format|
      format.html { redirect_to :poster }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :limit,:description,:profile_id)
    end
end

