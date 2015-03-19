class AddDocumentGroupToDocuments < ActiveRecord::Migration
  def change
    add_reference :documents, :document_group, index: true
  end
end
