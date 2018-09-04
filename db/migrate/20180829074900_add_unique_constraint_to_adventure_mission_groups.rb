class AddUniqueConstraintToAdventureMissionGroups < ActiveRecord::Migration[5.0]
  def change
    add_index :adventure_mission_groups,
              [:adventure_mission_id, :group_id],
              unique: true,
              # The auto generated name is too long, so we must choose one manually...
              name: 'index_adv_mission_groups_on_adm_mission_and_group'
  end
end
