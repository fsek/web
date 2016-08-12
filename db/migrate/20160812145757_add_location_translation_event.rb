class AddLocationTranslationEvent < ActiveRecord::Migration
  def up
    Event.add_translation_fields!({ location: :string },
                                  { migrate_data: true })
  end

  def down
    remove_column(:event_translations, :location)
  end
end
