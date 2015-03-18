class CreateDocumentGroupTypes < ActiveRecord::Migration
  def change
    create_table :document_group_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
