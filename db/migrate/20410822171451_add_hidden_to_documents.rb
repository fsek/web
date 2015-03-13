class AddHiddenToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :hidden, :boolean
  end
end
