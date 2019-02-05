class Admin::BaseController < ApplicationController
  skip_before_action :verify_terms_version

  def current_ability
    @current_ability ||= AdminAbility.new(current_user)
  end
end
