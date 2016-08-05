class AdventuresController < ApplicationController
  before_action :set_introduction
  load_permissions_and_authorize_resource through: :introduction

  def index
    @adventure = @adventures.published.first
    @total = @introduction.adventure_groups.for_index
  end

  def show
  end

  def archive
    @adventures = @introduction.adventures.published.includes(:translations)
  end

  private

  def set_introduction
    @introduction = Introduction.find_by!(slug: params[:introduction_id])
  end
end
