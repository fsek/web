class RemoveFieldsFromEvent < ActiveRecord::Migration
  def change
    remove_column(:events, :signup, :boolean)
    remove_column(:events, :last_reg, :datetime)
    remove_column(:events, :slots, :integer)
    remove_column(:events, :question, :string)
    remove_column(:events, :for_members)
  end
end
