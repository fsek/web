class ChangeToolRentings < ActiveRecord::Migration[5.0]
  def change
    add_column(:tool_rentings, :user_id, :integer, null: false)

    remove_column(:tool_rentings, :renter)
  end
end
