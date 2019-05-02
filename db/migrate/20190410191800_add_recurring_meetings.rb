class AddRecurringMeetings < ActiveRecord::Migration[5.0]
  def change
    create_table :recurring_meetings do |t|
      t.integer :recurring_meetings, :every, default: 0, null: false
    end
  end
end
