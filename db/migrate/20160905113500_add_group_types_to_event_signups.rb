class AddGroupTypesToEventSignups < ActiveRecord::Migration[5.0]
  def change
    add_column(:event_signups, :group_types, :string)
  end
end
