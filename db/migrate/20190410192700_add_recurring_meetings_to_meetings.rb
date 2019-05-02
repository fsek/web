class AddRecurringMeetingsToMeetings < ActiveRecord::Migration[5.0]
  def change
    add_reference :meetings, :recurring_meeting, index: true, foreign_key: true
  end
end
