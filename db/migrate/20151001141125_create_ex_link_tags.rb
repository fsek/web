class CreateExLinkTags < ActiveRecord::Migration
  def change
    create_table :ex_link_tags do |t|
      t.integer :tag_id, index: true
      t.integer :ex_link_id, index: true

      t.timestamps null: false
    end
  end
end
