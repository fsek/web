class Api::VersionsController < Api::BaseController
  # Don't forget to change this when adding app-breaking changes
  def index
    render json: { current_version: '1.0' }
  end
end
