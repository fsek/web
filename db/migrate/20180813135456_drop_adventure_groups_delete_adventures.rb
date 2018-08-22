class DropAdventureGroupsDeleteAdventures < ActiveRecord::Migration[5.0]
  def change
    drop_table :adventure_groups
    Adventure.delete_all
  end
end
