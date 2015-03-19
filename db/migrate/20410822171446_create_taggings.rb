class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.references :document, index: true
      t.references :tag, index: true

      t.timestamps
    end
  end
end
