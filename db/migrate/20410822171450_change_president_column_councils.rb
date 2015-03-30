class ChangePresidentColumnCouncils < ActiveRecord::Migration
  def change
    remove_column :councils, :president, :integer
    remove_column :councils, :vicepresident, :integer
    add_column :councils, :president_id, :integer
    add_column :councils, :vicepresident_id, :integer
  end
end
