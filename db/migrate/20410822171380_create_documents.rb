class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.attachment :pdf
      t.string :title
      t.boolean :public
      t.boolean :download
      t.string :category
      t.integer :profile_id

      t.timestamps
    end
  end
end
