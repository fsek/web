class ReplaceStilIdOnUser < ActiveRecord::Migration
  def change
    remove_column(:users, :stil_id, :string)
    add_column(:users, :student_id, :string)
  end
end
