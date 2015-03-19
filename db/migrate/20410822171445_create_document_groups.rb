class CreateDocumentGroups < ActiveRecord::Migration
  def change
    create_table :document_groups do |t|
      t.string :name
      t.date :production_date
      t.references :document_group_type

      t.timestamps
    end
  end
end
