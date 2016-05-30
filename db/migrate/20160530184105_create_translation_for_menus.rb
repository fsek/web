class CreateTranslationForMenus < ActiveRecord::Migration
  def up
    Menu.create_translation_table!({ name: :string },
                                   { migrate_data: true })
  end

  def down
    Menu.drop_translation_table! migrate_data: true
  end
end
