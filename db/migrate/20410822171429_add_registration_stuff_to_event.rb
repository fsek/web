class AddRegistrationStuffToEvent < ActiveRecord::Migration
  def change
    add_column :events, :registrable, :boolean
		add_column :events, :last_registration_date, :datetime
		add_column :events, :last_unregistration_date, :datetime
		add_column :events, :number_of_slots, :integer
  end
end
