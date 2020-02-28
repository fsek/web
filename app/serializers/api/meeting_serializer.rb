class Api::MeetingSerializer < ActiveModel::Serializer
  attributes(:id, :title, :start_date, :end_date, :council)

  def council
    object.council&.title
  end
end
