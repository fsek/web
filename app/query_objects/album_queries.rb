class AlbumQueries
  def self.photographer_names(album)
    album.images.select("distinct on (images.photographer_id) photographer_id, "\
                        "images.id as iid, users.id as uid, users.firstname as firstname, "\
                        " users.lastname as lastname")
      .joins("JOIN users on users.id = images.photographer_id")
  end
end
