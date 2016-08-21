class CreateEventUsers < ActiveRecord::Migration
  def change
    create_table :event_users do |t|
      t.references :user, index: true, foreign_key: true
      t.references :event, index: true, foreign_key: true
      t.references :group, index: true
      t.text :answer
      t.string :user_type
      t.datetime :deleted_at, index: true

      t.timestamps null: false
    end
  end
end
