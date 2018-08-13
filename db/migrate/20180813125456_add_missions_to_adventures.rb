class AddMissionsToAdventures < ActiveRecord::Migration[5.0]
  def change
    add_column(:adventure_groups, :missions, :jsonb)
    remove_column(:adventure_groups, :points)
  end
end
