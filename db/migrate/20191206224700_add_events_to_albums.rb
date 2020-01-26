class AddEventsToAlbums < ActiveRecord::Migration[5.0]
  def change
    add_reference :albums, :event, index: true, foreign_key: true
  end
end
