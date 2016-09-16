class AddCustomGroupFieldToEventUser < ActiveRecord::Migration
  def change
    add_column(:event_users, :group_custom, :string)
  end
end
