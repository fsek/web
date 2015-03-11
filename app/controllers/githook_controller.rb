class GithookController < ApplicationController
  def index
    ref = params[:ref]
    success = false
    if ref == "refs/heads/master"
    	success = system('/var/www/scripts/updatewrapper')
    elsif ref == "refs/heads/dev"
    	success = system('/var/www/scripts/updatewrapper-dev')
    end
    if success
      render :nothing => true, :status => 200
    else
      render :nothing => true, :status => 400
    end
  end
end
