class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :user, index: true, foreign_key: true
      t.text :content, null: false
      t.datetime :deleted_at, index: true
      t.integer :message_comments_count, null: false, default: 0

      t.timestamps null: false
    end
  end
end
