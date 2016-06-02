class CreateTranslationForNotices < ActiveRecord::Migration
  def up
    Notice.create_translation_table!({ title: :string, description: :text },
                                     { migrate_data: true })
  end

  def down
    Notice.drop_translation_table! migrate_data: true
  end
end
