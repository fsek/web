class AddTranslationsToAdventureMissions < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        AdventureMission.create_translation_table!({title: :string, description: :text},
                                          {migrate_data: true, remove_source_columns: true})
      end

      dir.down do
        AdventureMission.drop_translation_table!(migrate_data: true)
      end
    end
  end
end
