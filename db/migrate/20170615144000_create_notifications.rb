class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, index: true, foreign_key: true
      t.boolean :seen, null: false, default: false
      t.string :notifyable_type, null: false, index: true
      t.integer :notifyable_id, null: false, index: true
      t.string :mode, null: false

      t.timestamps null: false
    end
  end
end
