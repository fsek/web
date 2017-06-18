class RemoveForeignKeyFromMessages < ActiveRecord::Migration
  def change
    remove_foreign_key(:messages, :introductions)
  end
end
