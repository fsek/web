class AddReminderDatesToEventSignup < ActiveRecord::Migration[5.0]
  def change
    add_column(:event_signups, :sent_reminder, :datetime)
    add_column(:event_signups, :sent_position, :datetime)
  end
end
