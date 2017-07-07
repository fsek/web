class Api::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token

  include DeviseTokenAuth::Concerns::SetUserByToken

  rescue_from CanCan::AccessDenied do
    render(json: { success: false, errors: ["Invalid login credentials"] }, status: 401)
  end

  protected

  # Adds pagination meta data (from kaminari) to a serializer
  # Usage: `render json: @collection, meta: pagination_dict(collection)`
  def pagination_meta(collection)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }
  end
end
