class AdventuresController < ApplicationController
  before_action :set_introduction
  load_permissions_and_authorize_resource

  def index
    @adventure = @introduction.adventures.published.first

    redirect_to root_path, notice: t('.no_adventure') and return if @adventure.nil?

    if @adventure.adventure_missions.present?
      set_mission_variables(@adventure)
    end
  end

  def highscore
    @groups = AdventureQueries.highscore_list
  end

  def show
    if @adventure.adventure_missions.present?
      set_mission_variables(@adventure)
    end
  end

  def archive
    @adventures = @introduction.adventures.published.includes(:translations)
  end

  def set_mission_variables(adventure)
    @adventure_missions = adventure.adventure_missions

    @max_points_sum = @adventure_missions.sum(&:max_points)
    @group_points_sum = 0

    @group = current_user.groups.regular.last

    @adventure_missions.each do |am|
      @group_points_sum += am.points(@group)
    end

    @adventure_missions.map do |am|
      am.finished = am.finished?(@group)
      am.points = am.points(@group)
    end

    @grid = initialize_grid(@adventure_missions, locale: :sv, order: 'adventure_missions.index')
  end

  private

  def set_introduction
    @introduction = Introduction.current
  end
end
