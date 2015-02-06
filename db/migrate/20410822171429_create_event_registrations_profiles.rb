class CreateEventRegistrationsProfiles < ActiveRecord::Migration
  def change
    create_table :event_registrations_profiles, id: false do |t|
			t.integer :event_registration_id
			t.integer :profile_id
    end
		add_index :event_registrations_profiles, [:event_registration_id, :profile_id], name: "index_e_r_p"
  end
end
