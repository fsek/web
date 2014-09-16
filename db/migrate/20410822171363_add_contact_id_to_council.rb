class AddContactIdToCouncil < ActiveRecord::Migration
  def change
    add_column :councils, :contact_id, :integer
    remove_column :councils,:epost
  end
end
