class DropNotices < ActiveRecord::Migration[5.0]
  def up
    drop_table(:notices)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
