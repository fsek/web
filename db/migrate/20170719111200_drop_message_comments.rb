class DropMessageComments < ActiveRecord::Migration[5.0]
  def up
    drop_table(:message_comments)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
