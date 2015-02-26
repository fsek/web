class CreateEventRegistrations < ActiveRecord::Migration
  def change
    create_table :event_registrations do |t|
      t.integer :profile_id
      t.integer :event_id
      t.boolean :reserve_spot
      t.text :info_text

      t.timestamps
    end
  end
end
