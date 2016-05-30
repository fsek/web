class CreateTranslationForAlbums < ActiveRecord::Migration
  def up
    Album.create_translation_table!({ title: :string, description: :text },
                                    { migrate_data: true })
  end

  def down
    Album.drop_translation_table! migrate_data: true
  end
end
