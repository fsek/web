class AddTranslationsToCategories < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        Category.create_translation_table!({title: :string},
                                           {migrate_data: true, remove_source_columns: true})
      end

      dir.down do
        add_column(:categories, :title, :string)
        Category.drop_translation_table!(migrate_data: true)
      end
    end
  end
end
