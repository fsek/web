# encoding:UTF-8
class ProfilesController < ApplicationController
  
  before_action :login_required
  before_action :set_profile, only: [:show, :edit, :update,:remove_post, :avatar]
  before_action :authenticate, except: [:show,:avatar]

  def show
    if (@profile.owner?(current_user)) && (@profile.fresh?)
      redirect_to edit_profile_url(@profile), notice: t(:profile_add_information)
    end
  end


  def edit
    redirect_to(:back) unless current_user.profile == @profile
    # Calls method to set the first_post attribute if not set
    # /d.wessman
    @profile.check_posts
    rescue ActionController::RedirectBackError
      redirect_to root_path
  end


  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to @profile, notice: %(#{t(:your_profile)} #{t(:success_update)}) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

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

  # Action to show profile picture only already authenticated
  def avatar
    if @profile.avatar?
      if(params[:style] == "original" || params[:style] == "medium" || params[:style] == "thumb")
        send_file(@profile.avatar.path(params[:style]), filename:@profile.avatar_file_name, type: "image/jpg",disposition: 'inline',x_sendfile: true)
      else
        send_file(@profile.avatar.path(:medium), filename:@profile.avatar_file_name, type: "image/jpg",disposition: 'inline',x_sendfile: true)
      end
    end
  end

  private
    def authenticate
        redirect_to(root_path, alert: t('the_role.access_denied')) unless current_user &&  (current_user == @profile.user)
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(:name,:lastname, :program, :start_year,:avatar,:first_post,:stil_id,:email,:phone)
    end

end
