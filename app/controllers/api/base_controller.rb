class Api::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token

  # Remove when implemented in the app
  skip_before_action :verify_terms_version

  include DeviseTokenAuth::Concerns::SetUserByToken

  rescue_from CanCan::AccessDenied do
    render(json: { success: false, errors: ["Invalid login credentials"] }, status: 401)
  end
end
