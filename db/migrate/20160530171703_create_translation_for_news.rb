class CreateTranslationForNews < ActiveRecord::Migration
  def up
    News.create_translation_table!({ title: :string, content: :text },
                                   { migrate_data: true })
  end

  def down
    News.drop_translation_table! migrate_data: true
  end
end
