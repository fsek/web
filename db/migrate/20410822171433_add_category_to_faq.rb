class AddCategoryToFaq < ActiveRecord::Migration
  def change
    add_column :faqs, :category, :string
		add_index :faqs, :category
  end
end
