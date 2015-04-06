# encoding:UTF-8
class ProfilesController < ApplicationController
  load_permissions_and_authorize_resource

  def show
    if (@profile.owner?(current_user)) && (@profile.fresh?)
      redirect_to edit_profile_url(@profile), notice: t(:profile_add_information)
    end
  end


  def edit
    # Calls method to set the first_post attribute if not set
    # /d.wessman
    @profile.check_posts
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end


  def update
    if @profile.update(profile_params)
      redirect_to @profile, notice: %(#{t(:your_profile)} #{t(:success_update)})
    else
      render action: 'edit'
    end
  end

  def remove_post
    @post = Post.find(params[:post_id])
    @profile.posts.delete(@post)
    redirect_to edit_profile_path(@profile), notice: %(Du har inte längre posten #{@post}.)
    @profile.check_posts
  end

  # Action to show profile picture only already authenticated
  def avatar
    if @profile.avatar?
      if (params[:style] == 'original' || params[:style] == 'medium' || params[:style] == 'thumb')
        send_file(@profile.avatar.path(params[:style]), filename: @profile.avatar_file_name,
                  type: 'image/jpg', disposition: 'inline', x_sendfile: true)
      else
        send_file(@profile.avatar.path(:medium), filename: @profile.avatar_file_name,
                  type: 'image/jpg', disposition: 'inline', x_sendfile: true)
      end
    end
  end

  def search
    @search_profiles = Profile.search_names(params[:firstname], params[:lastname])
  end

  private

  def profile_params
    params.require(:profile).permit(:name, :lastname, :program, :start_year,
                                    :avatar, :first_post, :stil_id, :email, :phone)
  end

end
