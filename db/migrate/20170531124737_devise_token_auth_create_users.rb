class DeviseTokenAuthCreateUsers < ActiveRecord::Migration
  def up
    add_column :users, :provider, :string, null: false, default: "email"
    add_column :users, :uid, :string, null: false, default: ""
    add_column :users, :tokens, :text

    User.update_all("uid=email")

    add_index :users, [:uid, :provider], unique: true
  end

  def down
    remove_index :users, column: [:uid, :provider]
    remove_column :users, :provider
    remove_column :users, :uid
    remove_column :users, :tokens
  end
end
