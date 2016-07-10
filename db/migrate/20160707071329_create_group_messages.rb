class CreateGroupMessages < ActiveRecord::Migration
  def change
    create_table :group_messages do |t|
      t.references :group, index: true, foreign_key: true
      t.references :message, index: true, foreign_key: true
      t.datetime :deleted_at, index: true

      t.timestamps null: false
    end
  end
end
