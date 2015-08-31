class CreateMailAliases < ActiveRecord::Migration
  def change
    create_table :mail_aliases do |t|
      t.string :username, :null => false
      t.string :domain, :null => false
      t.string :target, :null => false
      t.datetime :updated_at, :null => false
    end

    # Force combination of username, domain, and target to be unique.
    add_index :mail_aliases, [ :username, :domain, :target ], :unique => true
    add_index :mail_aliases, [ :target ], :unique => false
  end
end
