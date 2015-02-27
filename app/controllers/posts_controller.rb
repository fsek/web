# encoding:UTF-8
class PostsController < ApplicationController
  before_filter :authenticate
  before_action :set_council
  before_action :set_edit
  before_action :set_post, only: [:show, :edit, :update, :destroy, :remove_profile,:add_profile_username]

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
      elsif @profile.name.blank?          
          redirect_to council_posts_path(@council), flash: {alert: 'Användaren :"' + @user.username.to_s + '" måste fylla i fler uppgifter i sin profil.'} 
      elsif @profile.posts.include?(@post)
         redirect_to council_posts_path(@council), flash: {alert: @profile.name.to_s + '(' + @user.username.to_s + ') har redan posten '+@post.title.to_s + '.'}         
      elsif (@post.limit != nil) && (@post.profiles.size >= @post.limit)
         redirect_to council_posts_path(@council), flash: {alert: @post.title.to_s + ' har sitt maxantal.'}           
      else 
        @post.profiles << @profile        
        redirect_to council_posts_path(@council), notice: @profile.name.to_s + ' (' + @profile.user.username.to_s + ') tilldelades posten '+@post.title.to_s + '.'
        if (@profile.first_post == nil)   
          @profile.update(first_post: @post.id)
        end            
      end
    end
   
  
  def index 
    if(@council) 
      @posts = @council.posts
    else
      @posts = Post.all
    end
    @post_grid = initialize_grid(@posts) 
  end
  
  # GET /news/new
  def new
    @post = @council.posts.build
    @councils = Council.order(title: :asc)
  end

  # GET /news/1/edit
  def edit
    @councils = Council.order(title: :asc)
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
      if @post.update_attributes(post_params)
        @council2 = Council.find_by_id(params[:post][:council])
        if(@council2) && (@council2.equal?(@council) == false)
          @council2.posts << @post
          @council = @council2          
        end                        
        format.html { redirect_to edit_council_post_path(@council,@post), notice: 'Posten uppdaterades!' }
        format.json { head :no_content }
      else
        @councils = Council.order(title: :asc)
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
    def post_params
      params.require(:post).permit(:title, :limit,:recLimit,:description,:elected_by,:elected_at,:styrelse,:car_rent,:council_id)
    end
    def authenticate
      flash[:error] = t('the_role.access_denied')
      redirect_to(:back) unless (current_user) && (current_user.moderator?(:poster))    
      rescue ActionController::RedirectBackError
        redirect_to root_path
    end
    def set_edit
      if(current_user) && (current_user.moderator?(:poster))
        @edit = true
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end
    def set_council    
     @council = Council.find_by_url(params[:council_id])        
    end
end

