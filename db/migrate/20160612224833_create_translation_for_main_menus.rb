class CreateTranslationForMainMenus < ActiveRecord::Migration
  def up
    MainMenu.create_translation_table!(name: :string)
  end

  def down
    MainMenu.drop_translation_table! migrate_data: true
  end
end
