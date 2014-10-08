class AddFieldsToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates,:phone,:string
    add_column :nominations,:phone,:string
    remove_column :nominations,:stil,:string
    add_column :nominations,:stil_id,:string
  end
end
