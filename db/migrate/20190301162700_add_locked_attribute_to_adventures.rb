class AddLockedAttributeToAdventures < ActiveRecord::Migration[5.0]
  def change
    add_column(:adventure_missions, :locked, :boolean, default: true, null: false)
  end
end
