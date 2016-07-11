class ChangeMessage < ActiveRecord::Migration
  def change
    add_column :messages, :by_admin, :boolean, null: false, default: false
  end
end
