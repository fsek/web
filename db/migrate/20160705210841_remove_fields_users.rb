class RemoveFieldsUsers < ActiveRecord::Migration
  def change
    remove_column(:users, :role_id, :integer)
    remove_column(:users, :username, :string)
  end
end
