class Api::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token

  include DeviseTokenAuth::Concerns::SetUserByToken

  rescue_from CanCan::AccessDenied do
    render(json: { success: false, errors: ["Invalid login credentials"] }, status: 401)
  end
end
