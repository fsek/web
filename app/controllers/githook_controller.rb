class GithookController < ApplicationController
  before_action :login_required, :only => [:dev, :master]
  before_action :authenticate, :only => [:dev, :master]

  def index
    request.body.rewind
    payload_body = request.body.read
    verify_signature(payload_body)
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

  def verify_signature(payload_body)
      signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['SECRET_TOKEN'], payload_body)
      return halt 500, "Signatures didn't match!" unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
  end
end
