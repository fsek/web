class ChangeMessageComment < ActiveRecord::Migration
  def change
    add_column :message_comments, :by_admin, :boolean, null: false, default: false
  end
end
