class ChangeGroups < ActiveRecord::Migration
  def change
    add_column :groups, :group_type, :string, default: 'regular', null: false
  end
end
