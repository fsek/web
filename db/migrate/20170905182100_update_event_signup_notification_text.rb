class UpdateEventSignupNotificationText < ActiveRecord::Migration[5.0]
  def up
    change_column(:event_signup_translations, :notification_message, :text)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
