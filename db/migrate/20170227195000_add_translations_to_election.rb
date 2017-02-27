class AddTranslationsToElection < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        Election.create_translation_table!({ title: :string, description: :text },
                                           { migrate_data: true, remove_source_columns: true })
      end

      dir.down do
        add_column(:council, :title, :string)
        add_column(:council, :description, :text)
        Election.drop_translation_table!(migrate_data: true)
      end
    end
  end
end
