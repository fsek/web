class AddCustomGroupFieldToEventUser < ActiveRecord::Migration[5.0]
  def change
    add_column(:event_users, :group_custom, :string)
  end
end
