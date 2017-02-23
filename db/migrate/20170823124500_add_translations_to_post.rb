class AddTranslationsToPost < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        Post.create_translation_table!({title: :string, description: :text},
                                       {migrate_data: true, remove_source_columns: true})
      end

      dir.down do
        add_column(:posts, :title, :string)
        add_column(:posts, :description, :text)
        Post.drop_translation_table!(migrate_data: true)
      end
    end
  end
end
