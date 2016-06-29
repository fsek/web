class CreateTranslationForPages < ActiveRecord::Migration
  def up
    Page.create_translation_table!({ title: { type: :string, null: :false, default: '' } },
                                   { migrate_data: true })
    PageElement.create_translation_table!({ text: :text, headline: :string }, { migrate_data: true })
  end

  def down
    Page.drop_translation_table!(migrate_data: true)
  end
end
