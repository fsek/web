class AddScheduledToMessages < ActiveRecord::Migration[5.1]
    def change
        add_column :messages, :scheduled, :boolean, default: :false, null: :false

        add_column :messages, :scheduled_time, :datetime
    end
end
