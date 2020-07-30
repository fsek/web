class AddPendingAttributesToAdventures < ActiveRecord::Migration[5.0]
  def change
    add_column(:adventure_missions, :require_acceptance, :boolean, default: true, null: false)

    # An existing record with pending: false is regarded completed and accepted
    add_column(:adventure_mission_groups, :pending, :boolean, default: false, null: false)
  end
end
