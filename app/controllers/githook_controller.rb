class GithookController < ApplicationController
  before_action :login_required, only: ['dev', 'master']
  before_action :authenticate, only: ['dev', 'master']
  before_action :verify_request_is_from_github, only: 'index'

  def index
    ref = params[:ref]
    success = false
    if ref == 'refs/heads/master'
      success, _ = pull_master
    elsif ref == 'refs/heads/dev'
      success, _ = pull_dev
    else
      success = true
    end
    render nothing: true, status: success ? 200 : 400
  end

  def dev
    @success, @output = pull_dev
    render :index
  end

  def master
    @success, @output = pull_master
    render :index
  end

  private
 
  def pull_dev
    out = `/var/www/scripts/updatewrapper-dev`
    return $?.exitstatus, out
  end

  def pull_master
    out = `/var/www/scripts/updatewrapper`
    return $?.exitstatus, out
  end

  def authenticate
    flash[:error] = t('the_role.access_denied')
    redirect_to(:back) unless user_signed_in? && current_user.admin?
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  def verify_request_is_from_github
    request.body.rewind
    payload_body = request.body.read
    verify_signature(payload_body)
  end

  def verify_signature(payload_body)
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new('sha1'),
      Constant.get('github_secret_token'), payload_body)
    return halt 500, "Signatures didn't match!" unless
      Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
  end
end
