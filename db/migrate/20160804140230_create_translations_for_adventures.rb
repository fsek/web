class CreateTranslationsForAdventures < ActiveRecord::Migration
  def up
    Adventure.create_translation_table!({ title: :string, content: :text })
  end

  def down
    Adventure.drop_translation_table!(migrate_data: true)
  end
end
