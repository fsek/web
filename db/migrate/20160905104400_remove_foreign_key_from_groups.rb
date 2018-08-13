class RemoveForeignKeyFromGroups < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key(:groups, :introductions)
  end
end
