class RemoveColumnsFromDocuments < ActiveRecord::Migration
  def change
    remove_column :documents, :download, :string
    remove_column :documents, :category, :string
    remove_column :documents, :profile_id, :string
  end
end
