class RemoveForeignKeyFromMessages < ActiveRecord::Migration
  def change
    remove_foreign_key(:messages, :introduction)
  end
end
