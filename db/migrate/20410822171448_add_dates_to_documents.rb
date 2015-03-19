class AddDatesToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :production_date, :date
    add_column :documents, :revision_date, :date
  end
end
