class CreateEventSignupTranslations < ActiveRecord::Migration
  def up
    EventSignup.create_translation_table!(question: :string)
  end

  def down
    EventSignup.drop_translation_table!(migrate_data: true)
  end
end
