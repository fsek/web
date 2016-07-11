class CreateMessageComments < ActiveRecord::Migration
  def change
    create_table :message_comments do |t|
      t.references :message, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.text :content, null: false
      t.datetime :deleted_at, index: true

      t.timestamps null: false
    end
  end
end
