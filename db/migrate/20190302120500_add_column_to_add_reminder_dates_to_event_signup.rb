class AddColumnToAddReminderDatesToEventSignup < ActiveRecord::Migration[5.0]
  def change
    add_column(:event_signups, :sent_open, :datetime)
  end
end
