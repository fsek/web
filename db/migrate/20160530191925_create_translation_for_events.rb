class CreateTranslationForEvents < ActiveRecord::Migration
  def up
    Event.create_translation_table!({ title: :string, description: :text, short: :string },
                                    { migrate_data: true })
  end

  def down
    Event.drop_translation_table! migrate_data: true
  end
end
