class AddNotificationMessageEventSignup < ActiveRecord::Migration
  def up
    EventSignup.add_translation_fields!(notification_message: :string)
  end

  def down
    remove_column(:event_signup_translations, :notification_message)
  end
end
