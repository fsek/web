class RemoveForeignKeyFromMessages < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key(:messages, :introductions)
  end
end
