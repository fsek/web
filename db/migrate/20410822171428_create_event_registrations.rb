class CreateEventRegistrations < ActiveRecord::Migration
  def change
    create_table :event_registrations do |t|
      t.integer :profile_id
      t.integer :event_id
      t.boolean :reserve_spot
      t.text :info_text

      t.timestamps
    end
    add_column :events, :registrable, :boolean
		add_column :events, :last_registration_date, :datetime
		add_column :events, :last_unregistration_date, :datetime
		add_column :events, :number_of_slots, :integer
  end
end
