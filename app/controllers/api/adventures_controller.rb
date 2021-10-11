class Api::AdventuresController < Api::BaseController
  before_action :set_introduction
  load_permissions_and_authorize_resource

  def index
    if @introduction.nil?
      render json: { error: 'No introduction exists' } and return
    elsif current_user.groups.regular.last.nil?
      render json: { error: 'No group exists' } and return
    elsif @introduction.adventures.published_asc.empty?
      render json: { error: 'No adventures avaliable' } and return
    end

    @adventures = @introduction.adventures.published_asc
    # Have to serialize manually here to put it together with is_mentor
    # Also passing current_user to the serializer scope because it doesn't
    # seem to be passed automatically
    @serializable_adventures = ActiveModelSerializers::SerializableResource.new(@adventures,
      {each_serializer: Api::AdventureSerializer::Index, scope: { 'current_user': current_user}})
    render json: { group_name: current_user.groups.regular.last.name,
                   is_mentor: current_user.mentor?,
                   total_group_points: current_user.groups.regular.last.total_published_adventure_points,
                   adventures: @serializable_adventures }
  end

  private

  def set_introduction
    @introduction = Introduction.current
  end
end
