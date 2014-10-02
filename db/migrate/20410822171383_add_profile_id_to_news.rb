class AddProfileIdToNews < ActiveRecord::Migration
  def change
    add_column :news,:profile_id,:integer
    remove_column :news,:author,:string
  end
end
