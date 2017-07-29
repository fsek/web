class EventSerializer < ActiveModel::Serializer
  attributes(:id, :title, :start, :end)
  attribute(:description) { object.description || '' }
  attribute(:location)
  attribute(:allday) { object.all_day? }
  attribute(:recurring) { false }
  attribute(:url) { Rails.application.routes.url_helpers.event_path(object.id) }
  attribute(:textColor) { 'black' }

  def start
    if object.all_day?
      object.starts_at.to_date.iso8601
    else
      object.starts_at.iso8601
    end
  end

  def end
    if object.all_day?
      (object.ends_at + 1.day).to_date.iso8601
    else
      object.ends_at.iso8601
    end
  end
end
