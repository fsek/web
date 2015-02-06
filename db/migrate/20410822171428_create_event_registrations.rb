class CreateEventRegistrations < ActiveRecord::Migration
  def change
    create_table :event_registrations do |t|
      t.integer :size
      t.datetime :last_registration_date
			t.integer :event_id
      t.timestamps
    end
  end
end
