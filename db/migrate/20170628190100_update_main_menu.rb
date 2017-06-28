class UpdateMainMenu < ActiveRecord::Migration[5.0]
  def change
    add_column(:main_menus, :visible, :boolean, default: true, null: false)
  end
end
