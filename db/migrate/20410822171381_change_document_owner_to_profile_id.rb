class ChangeDocumentOwnerToProfileId < ActiveRecord::Migration
  def change
    remove_column :documents,:owner,:integer
    add_column :documents,:profile_id,:integer
  end
end
