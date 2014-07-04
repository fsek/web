# encoding:UTF-8
class ProfilesController < ApplicationController
  
  before_filter :login_required
  before_filter :authenticate_user!  
  
  before_action :set_profile, only: [:show, :edit, :update,:remove_post]  
  
  

  def remove_post
    @post = Post.find(params[:post_id])
    @profile.posts.delete(@post)    
    respond_to do |format|
      format.html { redirect_to edit_profile_path(@profile), notice: 'Du har inte längre posten '+@post.title + '.'}
      if @profile.posts.count == 0
        @profile.update(first_post:  nil)
      end
    end 
  end
  # GET /profiles/1
  # GET /profiles/1.json
  def show

    if @profile.created_at == @profile.updated_at
      
      redirect_to edit_profile_url(@profile) 
    end
  end

  # GET /profiles/1/edit
  def edit
    redirect_to(:back) unless current_user.profile == @profile    
    if true   
      if (@profile.posts.count > 0) && (@profile.first_post == nil)
        @profile.update(first_post: @profile.posts.first.id)
      end
    @no_profile_data = @profile.created_at == @profile.updated_at
    end
    rescue ActionController::RedirectBackError
      redirect_to root_path
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to @profile, notice: 'Din profil uppdaterades!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end
    def set_user
      @user = User.find(Profile.find(params[:id]).user_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(:name, :program, :start_year,:avatar,:first_post)
    end

end
