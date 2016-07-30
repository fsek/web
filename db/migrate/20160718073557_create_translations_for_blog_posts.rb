class CreateTranslationsForBlogPosts < ActiveRecord::Migration
  def up
    BlogPost.create_translation_table!({ title: :string, preamble: :text, content: :text })
  end

  def down
    BlogPost.drop_translation_table!(migrate_data: true)
  end
end
