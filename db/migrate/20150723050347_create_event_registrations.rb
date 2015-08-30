class CreateEventRegistrations < ActiveRecord::Migration
  def change
    create_table :event_registrations do |t|
      t.integer :user_id
      t.integer :event_id
      t.boolean :reserve
      t.datetime :removed_at
      t.integer :remover_id
      t.text :comment

      t.timestamps null: false
    end
  end
end
