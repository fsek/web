class GithookController < ApplicationController
  before_action :login_required
  before_action :authenticate

  def index
    ref = params[:ref]
    success = false
    if ref == "refs/heads/master"
      success, _ = pull_master
    elsif ref == "refs/heads/dev"
      success, _ = pull_dev
    end
    if success
      render :nothing => true, :status => 200
    else
      render :nothing => true, :status => 400
    end
  end

  def dev
    @success, @output = pull_dev
    render :index
  end

  def master
    @success, @output = pull_master
    render :index
  end

  def pull_dev
    out = `/var/www/scripts/updatewrapper-dev`
    return $?.exitstatus, out
  end

  def pull_master
    out = `/var/www/scripts/updatewrapper`
    return $?.exitstatus, out
  end

  def authenticate
    flash[:error] = t("the_role.access_denied")
    redirect_to(:back) unless (current_user) && (current_user.moderator?(:val))
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end
end
