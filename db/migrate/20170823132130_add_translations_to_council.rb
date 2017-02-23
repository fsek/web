class AddTranslationsToCouncil < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        Council.create_translation_table!({title: :string},
                                          {migrate_data: true, remove_source_columns: true})
      end

      dir.down do
        add_column(:council, :title, :string)
        Council.drop_translation_table!(migrate_data: true)
      end
    end
  end
end
