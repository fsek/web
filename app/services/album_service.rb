class AlbumService
  def initialize
    @uploaded = 0
  end

  def uploaded
    @uploaded || 0
  end

  def upload_images(album)
    state = true
    if album.image_upload.present?
      album.image_upload.each do |img|
        new_img = album.images.new(file: img, photographer_id: album.photographer_user,
                                   photographer_name: album.photographer_name)
        if new_img.save
          @uploaded += 1
        else
          album.errors.add(:image_upload, new_img.filename)
          state = false
        end
      end
    end

    state
  end

  def create_from_event(params)
    event_id = params[:event_id]
    event = Event.find(event_id)

    params_from_event = {
      title_sv: event.title_sv,
      title_en: event.title_en,
      description_sv: event.description_sv,
      description_en: event.description_en,
      location: event.location,
      start_date: event.starts_at,
      end_date: event.ends_at
    }

    @album = Album.new(params_from_event)
    @album.event_id = event_id.to_i

    if @album.save
      @album
    else
      nil
    end
  end
end
