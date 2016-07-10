class ChangeUsers < ActiveRecord::Migration
  def change
    add_column :users, :display_phone, :boolean, null: false, default: false
  end
end
