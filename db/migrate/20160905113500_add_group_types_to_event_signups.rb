class AddGroupTypesToEventSignups < ActiveRecord::Migration
  def change
    add_column(:event_signups, :group_types, :string)
  end
end
