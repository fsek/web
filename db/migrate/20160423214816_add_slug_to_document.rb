class AddSlugToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :slug, :string, index: true
  end
end
