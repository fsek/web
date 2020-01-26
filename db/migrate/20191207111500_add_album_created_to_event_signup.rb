class AddAlbumCreatedToEventSignup < ActiveRecord::Migration[5.0]
  def change
    add_column(:event_signups, :sent_album_created, :datetime)
  end
end
