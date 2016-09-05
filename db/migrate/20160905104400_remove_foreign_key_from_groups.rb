class RemoveForeignKeyFromGroups < ActiveRecord::Migration
  def change
    remove_foreign_key(:groups, :introduction)
  end
end
