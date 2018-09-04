class ChangeEventSignupIndex < ActiveRecord::Migration[5.0]
  def up
    remove_index(:event_signups, name: 'event_signups_unique_event_index')
  end

  def down
    add_index(:event_signups, :event_id, unique: true,
                                         name: 'event_signups_unique_event_index')
  end
end
