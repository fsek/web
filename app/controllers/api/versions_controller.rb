class Api::VersionsController < Api::BaseController
  # Don't forget to change this when adding app-breaking changes
  def index
    render json: {
      current_version: Versions.get(:api).to_s,
      api_version: Versions.get(:api),
      terms_version: Versions.get(:terms)
    }
  end
end
