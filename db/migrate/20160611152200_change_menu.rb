class ChangeMenu < ActiveRecord::Migration
  def change
    add_column :menus, :header, :boolean, null: false, default: false
    add_column :menus, :column, :integer, null: false, default: 1
    add_reference :menus, :main_menu, index: true, foreign_key: true
    remove_column :menus, :location, :string

    reversible do |change|
      change.up do
        change_column_default :menus, :visible, true
      end

      change.down do
        change_column_default :menus, :visible, false
      end
    end
  end
end
