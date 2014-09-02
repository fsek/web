# encoding:UTF-8
class PostsController < ApplicationController
  include TheRole::Controller
  before_filter :authenticate_user!, only: [:new,:edit,:create,:update,:destroy]
  before_action :set_council
  before_action :set_post, only: [:show, :edit, :update, :destroy, :remove_profile,:add_profile_username]
  
  before_filter :authenticate_editor_poster! 

  def remove_profile
    @profile = Profile.find_by_id(params[:profile_id])
    @post.profiles.delete(@profile)    
    respond_to do |format|
    format.html { redirect_to council_posts_path(@council), notice: @profile.name.to_s + ' har inte längre posten ' + @post.title.to_s + '.'}
    end 
  end
  def add_profile_username
    @user = User.find_by(username: params[:username])
    if @user != nil
      @profile = @user.profile
    end
      if @profile == nil
          respond_to do |format|
         format.html { redirect_to council_posts_path(@council), flash: {alert: 'Hittade ingen användare med det användarnamnet.'}}
         end
      elsif @profile.name == nil || @profile.name == ""
          respond_to do |format|
         format.html { redirect_to council_posts_path(@council), flash: {alert: 'Användaren :"' + @user.username.to_s + '" måste fylla i fler uppgifter i sin profil.' }}
         end
      elsif @profile.posts.include?(@post)
         respond_to do |format|
         format.html { redirect_to council_posts_path(@council), flash: {alert: @profile.name.to_s + '(' + @user.username.to_s + ') har redan posten '+@post.title.to_s + '.'}}
         end
      elsif @post.limit != nil && @post.profiles.size >= @post.limit
        respond_to do |format|
         format.html { redirect_to council_posts_path(@council), flash: {alert: @post.title.to_s + ' har sitt maxantal.'}}
         end   
      else 
        @post.profiles << @profile
        respond_to do |format|
          format.html { redirect_to council_posts_path(@council), notice: @profile.name.to_s + ' (' + @profile.user.username.to_s + ') tilldelades posten '+@post.title.to_s + '.'}
            if (@profile.first_post == nil)   
              @profile.update(first_post: @post.id)
            end
          end  
      end
    end
   
  
  def index  
    @posts = @council.posts 
  end
  # GET /news/1
  # GET /news/1.json
  
  def show    
  end

  # GET /news/new
  def new
    @post = @council.posts.build
  end

  # GET /news/1/edit
  def edit
  end

  # POST /news
  # POST /news.json
  def create
    @post = @council.posts.build(post_params)        
    respond_to do |format|
      if @post.save        
        format.html { redirect_to council_posts_path(@council), notice: 'Posten skapades!' }
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
        format.html { redirect_to edit_counciL_post_path(@council,@post), notice: 'Posten uppdaterades!' }
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
      format.html { redirect_to council_posts_path(@council) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end
    def set_council    
     @council = Council.find_by_url(params[:council_id])     
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :limit,:description,:profile_id,:council_id,:post_id)
    end
end

